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
  var tender = Rxn<TenderModel>();
  final offers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeTender();
    fetchOffers();
  }

  @override
  void onClose() {
    // Cancel Firestore subscriptions if any
    super.onClose();
  }

  void initializeTender() {
    final args = Get.arguments;
    if (args is TenderModel) {
      tender.value = args;
      _listenToTenderUpdates(args.id);
    } else if (args is Map && args['tenderId'] != null) {
      isLoading.value = true;
      _listenToTenderUpdates(args['tenderId']);
    } else {
      Get.snackbar('error'.tr(), 'tender_not_found'.tr());
      Get.back();
    }
  }

  void _listenToTenderUpdates(String tenderId) {
    firebaseService.firestore
        .collection('projects')
        .doc(tenderId)
        .snapshots()
        .listen(
          (snapshot) async {
            if (snapshot.exists) {
              tender.value = TenderModel.fromJson(
                snapshot.data()!,
                snapshot.id,
              );
              isLoading.value = false;
            } else {
              Get.snackbar('error'.tr(), 'tender_not_found'.tr());
              Get.back();
            }
          },
          onError: (e) {
            debugPrint('Error listening to tender updates: $e');
            Get.snackbar('error'.tr(), 'tender_not_found'.tr());
            isLoading.value = false;
            Get.back();
          },
        );
  }

  void fetchOffers() {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null && tender.value?.userId == userId) {
      firebaseService.firestore
          .collection('projects')
          .doc(tender.value?.id)
          .collection('offers')
          .snapshots()
          .listen(
            (snapshot) {
              offers.assignAll(
                snapshot.docs
                    .map((doc) => {...doc.data(), 'id': doc.id})
                    .toList(),
              );
            },
            onError: (e) {
              debugPrint('Error fetching offers: $e');
              Get.snackbar('error'.tr(), 'failed_to_fetch_offers'.tr());
            },
          );
    }
  }

  Future<void> updateOfferStatus(String offerId, String status) async {
    if (tender.value?.stage != 'evaluated') {
      Get.snackbar('error'.tr(), 'cannot_update_offer_status'.tr());
      return;
    }
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.value!.id)
          .collection('offers')
          .doc(offerId)
          .update({'status': status});
      final offer = offers.firstWhere((o) => o['id'] == offerId);
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
              ? '${'offer_accepted_notification'.tr()}${tender.value!.projectName}'
              : '${'offer_rejected_notification'.tr()}${tender.value!.projectName}',
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
    final currentIndex = validStages.indexOf(tender.value!.stage);
    final newIndex = validStages.indexOf(newStage);
    if (newIndex <= currentIndex || newIndex > currentIndex + 1) {
      Get.snackbar('error'.tr(), 'invalid_stage_transition'.tr());
      return;
    }
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.value!.id)
          .update({
            'stage': newStage,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });
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
            '${'tender_stage_updated'.tr()}${tender.value?.projectName}',
            '${'stage_updated_notification'.tr()}${tender.value?.projectName}',
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
          .doc(tender.value!.id)
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
