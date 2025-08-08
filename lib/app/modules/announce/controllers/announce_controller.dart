import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import '../../../data/services/firebase_service.dart';
import '../../../data/services/gofile_upload_service.dart';
import '../../auth/controllers/auth_controller.dart';

class AnnounceController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  final GofileUploadService gofileUploadService = GofileUploadService();
  var isLoading = false.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var folderId = Rxn<String>();
  var selectedFile = Rxn<FilePickerResult>();
  final projectNameController = TextEditingController();
  final serviceTypeController = TextEditingController();
  final requirementsController = TextEditingController();
  final budgetController = TextEditingController();
  final legalRequirementsController = TextEditingController();
  final categoryController = TextEditingController();
  final wilayaController = TextEditingController();

  @override
  void onClose() {
    projectNameController.dispose();
    serviceTypeController.dispose();
    requirementsController.dispose();
    budgetController.dispose();
    legalRequirementsController.dispose();
    categoryController.dispose();
    wilayaController.dispose();
    super.onClose();
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  Future<void> announceTender(
    String legalRequirements,
    FilePickerResult? selectedFile, {
    String? projectId,
    required String projectName,
    required String serviceType,
    required String requirements,
    required double budget,
    required String category,
    required String wilaya,
  }) async {
    isLoading.value = true;
    try {
      final userId = firebaseService.auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
        return;
      }
      if (startDate.value == null || endDate.value == null) {
        Get.snackbar('error'.tr(), 'please_select_dates'.tr());
        return;
      }
      if (endDate.value!.isBefore(startDate.value!)) {
        Get.snackbar('error'.tr(), 'end_date_before_start'.tr());
        return;
      }

      String? documentUrl;
      if (selectedFile != null) {
        final file = File(selectedFile.files.single.path!);
        final mimeType = lookupMimeType(file.path);
        if (mimeType == null ||
            ![
              'image/jpeg',
              'image/png',
              'application/pdf',
            ].contains(mimeType)) {
          Get.snackbar('error'.tr(), 'unsupported_file_type'.tr());
          return;
        }
        documentUrl = await gofileUploadService.uploadFile(
          file,
          folderId: folderId.value,
        );
        debugPrint('Uploaded file URL: $documentUrl');
      }

      final tenderData = {
        'userId': userId,
        'projectName': projectName,
        'serviceType': serviceType,
        'requirements': requirements,
        'budget': budget,
        'legalRequirements': legalRequirements,
        'startDate': startDate.value,
        'endDate': endDate.value,
        'createdAt': DateTime.now(),
        'stage': 'announced',
        'documentName': selectedFile?.files.single.name,
        'documentUrl': documentUrl,
        'category': category,
        'wilaya': wilaya,
        'offers': [],
      };

      if (projectId != null) {
        await firebaseService.firestore
            .collection('projects')
            .doc(projectId)
            .update(tenderData);
      } else {
        await firebaseService.firestore.collection('projects').add(tenderData);
      }
      Get.snackbar('success'.tr(), 'tender_published'.tr());
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint('Error announcing tender: $e');
      Get.snackbar('error'.tr(), 'publish_tender_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
