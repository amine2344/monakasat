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
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyOffers();
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
      } else {
        querySnapshot = await firebaseService.firestore
            .collection('projects')
            .where(
              'offers',
              arrayContainsAny: [
                {'contractorId': userId},
              ],
            )
            .get();
      }

      myOffers.value = querySnapshot.docs
          .map(
            (doc) => TenderModel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
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
        return 'pending'.tr();
      default:
        return stage;
    }
  }

  void trackInteraction(String tenderId, String action) {
    debugPrint('Tracked interaction: $action for tender $tenderId');
    // Implement analytics if needed
  }
}
