import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/services/firebase_service.dart';
import '../../../data/models/tender_model.dart';
import '../../auth/controllers/auth_controller.dart';

class MyOffersController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  var myOffers = <TenderModel>[].obs;
  var myOfferDetails = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchMyOffers();
    });
  }

  Future<void> fetchMyOffers() async {
    try {
      isLoading.value = true;
      final userId = firebaseService.auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
        return;
      }

      final isProjectOwner =
          authController.selectedRole.value == 'project_owner';
      QuerySnapshot querySnapshot;

      if (isProjectOwner) {
        querySnapshot = await firebaseService.firestore
            .collection('projects')
            .where('userId', isEqualTo: userId)
            .get();
        myOffers.value = querySnapshot.docs
            .map(
              (doc) => TenderModel.fromJson(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ),
            )
            .toList();
        myOfferDetails.value = List.filled(myOffers.length, {});
      } else {
        // Fetch tenders where the user has submitted an offer
        final offerSnapshot = await firebaseService.firestore
            .collectionGroup('offers')
            .where('contractorId', isEqualTo: userId)
            .get();

        final tenderIds = offerSnapshot.docs
            .map((doc) => doc.reference.parent.parent!.id)
            .toSet();
        final tenders = <TenderModel>[];
        final offerDetails = <Map<String, dynamic>>[];

        for (var tenderId in tenderIds) {
          final tenderDoc = await firebaseService.firestore
              .collection('projects')
              .doc(tenderId)
              .get();
          if (tenderDoc.exists) {
            tenders.add(
              TenderModel.fromJson(
                tenderDoc.data() as Map<String, dynamic>,
                tenderDoc.id,
              ),
            );
            final offerDoc = offerSnapshot.docs.firstWhere(
              (doc) => doc.reference.parent.parent!.id == tenderId,
            );
            offerDetails.add({...offerDoc.data(), 'id': offerDoc.id});
          }
        }

        myOffers.value = tenders;
        myOfferDetails.value = offerDetails;
      }

      debugPrint('Fetched ${myOffers.length} offers');
    } catch (e) {
      debugPrint('Error fetching offers: $e');
      Get.snackbar('error'.tr(), 'no_offers_available'.tr());
    } finally {
      isLoading.value = false;
    }
  }

  String getStageText(String stage) {
    switch (stage) {
      case 'announced':
        return 'announced'.tr();
      case 'envelope_opened':
        return 'envelope_opened'.tr();
      case 'evaluated':
        return 'evaluated'.tr();
      case 'contract_signed':
        return 'contract_signed'.tr();
      case 'execution':
        return 'execution'.tr();
      case 'completed':
        return 'completed'.tr();
      default:
        return stage;
    }
  }

  void trackInteraction(String tenderId, String action) {
    debugPrint('Tracked interaction: $action for tender $tenderId');
  }
}
