import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

import '../../../data/models/tender_model.dart';
import '../../../data/services/cloudinary_files_uploader.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class TenderDetailsContractorController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  late TenderModel tender;
  final userOffer = Rx<Map<String, dynamic>?>(null);
  var isLoading = false.obs;
  final selectedFile = Rxn<FilePickerResult>();
  final backendUrl = const String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://cloudinaryuploader.onrender.com',
  );

  @override
  void onInit() {
    super.onInit();
    initializeTender();
    fetchUserOffer();
  }

  @override
  void onClose() {
    selectedFile.value = null;
    super.onClose();
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

  void fetchUserOffer() {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null) {
      firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .where('contractorId', isEqualTo: userId)
          .snapshots()
          .listen(
            (snapshot) {
              if (snapshot.docs.isNotEmpty) {
                userOffer.value = {
                  ...snapshot.docs.first.data(),
                  'id': snapshot.docs.first.id,
                };
              } else {
                userOffer.value = null;
              }
            },
            onError: (e) {
              debugPrint('Error fetching user offer: $e');
              Get.snackbar('error'.tr(), 'failed_to_fetch_offers'.tr());
            },
          );
    }
  }

  Future<void> pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        selectedFile.value = result;
      }
    } catch (e) {
      debugPrint('Error picking document: $e');
      Get.snackbar('error'.tr(), 'failed_to_pick_document'.tr());
    }
  }

  Future<void> submitOffer(
    String offerAmount,
    String offerDetails, [
    String? executionDuration,
  ]) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
      return;
    }
    isLoading.value = true;
    try {
      String? documentUrl;
      String? documentName;
      if (selectedFile.value != null) {
        final file = selectedFile.value!.files.single;
        final mimeType = lookupMimeType(file.path ?? '');
        if (mimeType == null ||
            ![
              'image/jpeg',
              'image/png',
              'application/pdf',
            ].contains(mimeType)) {
          Get.snackbar('error'.tr(), 'unsupported_file_type'.tr());
          isLoading.value = false;
          return;
        }
        debugPrint('Uploading document: ${file.path}, MIME: $mimeType');
        final cloudinaryUploadService = CloudinaryUploadService(
          backendUrl: backendUrl,
        );
        final cloudinaryResponse = await cloudinaryUploadService.uploadFile(
          File(file.path!),
        );
        debugPrint(
          'CLOUDINARY DOCUMENT RESPONSE  ====> ${cloudinaryResponse?.toJson()}',
        );
        documentUrl = cloudinaryResponse?.effectiveUrl;
        documentName = file.name;
        debugPrint('Uploaded document URL: $documentUrl');
      }

      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .add({
            'contractorId': userId,
            'contractorName': authController.currentUser?.userName ?? 'Unknown',
            'offerAmount': double.parse(offerAmount),
            'offerDetails': offerDetails,
            'executionDuration':
                executionDuration != null && executionDuration.isNotEmpty
                ? int.tryParse(executionDuration)
                : null,
            'documentUrl': documentUrl,
            'documentName': documentName,
            'submittedAt': DateTime.now(),
            'status': 'pending',
          });
      Get.snackbar('success'.tr(), 'offer_submitted'.tr());
      selectedFile.value = null; // Clear file after submission
    } catch (e) {
      Get.snackbar('error'.tr(), 'submit_offer_failed'.tr());
      debugPrint('Error submitting offer: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
