import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class TenderDetailsOwnerController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  late TenderModel tender;
  final offers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeTender();
    fetchOffers();
  }

  Future<void> initializeTender() async {
    final args = Get.arguments;
    if (args is TenderModel) {
      tender = args;
    } else if (args is Map && args['tenderId'] != null) {
      isLoading.value = true;
      final fetchedTender = await firebaseService.getTenderById(
        args['tenderId'],
      );
      if (fetchedTender != null) {
        tender = fetchedTender;
      } else {
        Get.snackbar('error'.tr(), 'tender_not_found'.tr());
        Get.back();
      }
      isLoading.value = false;
    }
  }

  void fetchOffers() {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null && tender.userId == userId) {
      firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .snapshots()
          .listen((snapshot) {
            offers.assignAll(
              snapshot.docs
                  .map((doc) => {...doc.data(), 'id': doc.id})
                  .toList(),
            );
          });
    }
  }

  Future<void> updateOfferStatus(String offerId, String status) async {
    if (tender.stage != 'evaluated') {
      Get.snackbar('error'.tr(), 'cannot_update_offer_status'.tr());
      return;
    }
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .doc(offerId)
          .update({'status': status});
      final offer = offers.firstWhere((o) => o['id'] == offerId);
      // Fetch contractor's deviceToken
      final contractorDoc = await firebaseService.firestore
          .collection('users')
          .doc(offer['contractorId'])
          .get();
      final deviceToken = contractorDoc.data()?['deviceToken'] as String?;
      if (deviceToken != null && deviceToken.isNotEmpty) {
        debugPrint(
          'Sending notification to contractor: ${offer['contractorId']}, token: $deviceToken',
        );
        await firebaseService.sendNotification(
          deviceToken,
          'offer_status_updated'.tr(),
          status == 'accepted'
              ? 'offer_accepted_notification'.tr()
              : 'offer_rejected_notification'.tr(),
        );
      }
      Get.snackbar(
        'success'.tr(),
        status == 'accepted' ? 'offer_accepted'.tr() : 'offer_rejected'.tr(),
      );
      if (status == 'accepted') {
        await updateTenderStage('contract_signed');
      }
    } catch (e) {
      Get.snackbar('error'.tr(), 'update_offer_failed'.tr());
      debugPrint('Error updating offer status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTenderStage(String newStage) async {
    final validStages = [
      'announced',
      'envelope_opened',
      'evaluated',
      'contract_signed',
      'execution',
      'completed',
    ];
    final currentIndex = validStages.indexOf(tender.stage);
    final newIndex = validStages.indexOf(newStage);
    if (newIndex <= currentIndex || newIndex > currentIndex + 1) {
      Get.snackbar('error'.tr(), 'invalid_stage_transition'.tr());
      return;
    }
    /* if (tender.stage ==
        'announced' /* &&
        newStage ==
            'envelope_opened' */ /* &&
        tender.endDate.isAfter(DateTime.now()) */ ) {
      Get.snackbar('error'.tr(), 'cannot_open_envelopes_before_end_date'.tr());
      return;
    } */
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .update({
            'stage': newStage,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });
      tender = TenderModel.fromJson({
        ...tender.toJson(),
        'stage': newStage,
      }, tender.id);
      // Notify all contractors who submitted offers
      for (var offer in offers) {
        final contractorDoc = await firebaseService.firestore
            .collection('users')
            .doc(offer['contractorId'])
            .get();
        final deviceToken = contractorDoc.data()?['deviceToken'] as String?;
        if (deviceToken != null && deviceToken.isNotEmpty) {
          debugPrint(
            'Sending stage update notification to contractor: ${offer['contractorId']}, token: $deviceToken',
          );
          await firebaseService.sendNotification(
            deviceToken,
            'tender_stage_updated'.tr(),
            'stage_updated_notification'.tr(),
          );
        }
      }
      if (newStage == 'envelope_opened') {
        await generateEnvelopeOpeningReport();
      }
      Get.snackbar('success'.tr(), 'stage_updated'.tr());
    } catch (e) {
      Get.snackbar('error'.tr(), 'stage_update_failed'.tr());
      debugPrint('Error updating tender stage: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateEnvelopeOpeningReport() async {
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('reports')
          .add({
            'type': 'envelope_opening',
            'generatedAt': Timestamp.fromDate(DateTime.now()),
            'offers': offers
                .map(
                  (o) => {
                    'contractorName': o['contractorName'],
                    'offerAmount': o['offerAmount'],
                    'offerDetails': o['offerDetails'],
                    'status': o['status'],
                  },
                )
                .toList(),
          });
      Get.snackbar('success'.tr(), 'envelope_opening_report_generated'.tr());
    } catch (e) {
      Get.snackbar('error'.tr(), 'report_generation_failed'.tr());
      debugPrint('Error generating report: $e');
    }
  }
}
