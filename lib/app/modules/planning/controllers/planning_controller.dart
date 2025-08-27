import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/constants/app_constants.dart';
import '../../../data/services/cloudinary_files_uploader.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class PlanningController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  final CloudinaryUploadService cloudinaryUploadService =
      CloudinaryUploadService(backendUrl: backendUrl);
  var isLoading = false.obs;
  var currentStep = 1.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var folderId = Rxn<String>();
  var selectedFile = Rxn<FilePickerResult>();
  var selectedImage = Rxn<FilePickerResult>();
  final projectNameController = TextEditingController();
  final serviceTypeController = TextEditingController();
  final requirementsController = TextEditingController();
  final budgetController = TextEditingController();
  final legalRequirementsController = TextEditingController();
  final categoryController = TextEditingController();
  final wilayaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final projectId = Get.arguments?['projectId'] as String?;
    if (projectId != null) {
      isLoading.value = true;
      firebaseService.firestore
          .collection('projects')
          .doc(projectId)
          .get()
          .then(
            (doc) {
              if (doc.exists) {
                final data = doc.data()!;
                projectNameController.text = data['projectName'] ?? '';
                serviceTypeController.text = data['serviceType'] ?? '';
                requirementsController.text = data['requirements'] ?? '';
                budgetController.text = data['budget']?.toString() ?? '';
                legalRequirementsController.text =
                    data['legalRequirements'] ?? '';
                categoryController.text = data['category'] ?? '';
                wilayaController.text = data['wilaya'] ?? '';
                startDate.value = (data['startDate'] as Timestamp?)?.toDate();
                endDate.value = (data['endDate'] as Timestamp?)?.toDate();
                folderId.value = data['folderId'];
                // Note: Cannot reload FilePickerResult for documentUrl/featuredImageUrl
              }
              isLoading.value = false;
            },
            onError: (e) {
              debugPrint('Error loading project: $e');
              Get.snackbar('error'.tr(), 'failed_to_load_project'.tr());
              isLoading.value = false;
            },
          );
    }
  }

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

  void nextStep() {
    debugPrint(
      'Step 1 data: ${projectNameController.text}, ${serviceTypeController.text}, ${categoryController.text}',
    );
    currentStep.value = 2;
  }

  void previousStep() {
    currentStep.value = 1;
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  Future<void> announceTender({String? projectId}) async {
    isLoading.value = true;
    debugPrint("CREATING TENDER");
    try {
      final userId = firebaseService.auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
        return;
      }

      if (projectNameController.text.isEmpty ||
          serviceTypeController.text.isEmpty ||
          requirementsController.text.isEmpty ||
          budgetController.text.isEmpty ||
          categoryController.text.isEmpty ||
          wilayaController.text.isEmpty) {
        Get.snackbar('error'.tr(), 'please_fill_all_fields'.tr());
        return;
      }

      final budget = double.tryParse(budgetController.text);
      if (budget == null) {
        Get.snackbar('error'.tr(), 'invalid_budget'.tr());
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
      if (selectedFile.value != null) {
        final file = File(selectedFile.value!.files.single.path!);
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

        debugPrint('Uploading document: ${file.path}, MIME: $mimeType');
        final cloudinaryResponse = await cloudinaryUploadService.uploadFile(
          file,
        );
        debugPrint(
          'CLOUDINARY DOCUMENT RESPONSE  ====> ${cloudinaryResponse?.toJson()}',
        );
        documentUrl = cloudinaryResponse?.effectiveUrl;
        debugPrint('Uploaded document URL: $documentUrl');
      }

      String? featuredImageUrl;
      if (selectedImage.value != null) {
        final imageFile = File(selectedImage.value!.files.single.path!);
        final mimeType = lookupMimeType(imageFile.path);
        if (mimeType == null ||
            !['image/jpeg', 'image/png'].contains(mimeType)) {
          Get.snackbar('error'.tr(), 'unsupported_image_type'.tr());
          return;
        }

        debugPrint(
          'Uploading featured image: ${imageFile.path}, MIME: $mimeType',
        );
        final cloudinaryResponse = await cloudinaryUploadService.uploadFile(
          imageFile,
        );
        debugPrint(
          'CLOUDINARY IMAGE RESPONSE  ====> ${cloudinaryResponse?.toJson()}',
        );
        featuredImageUrl = cloudinaryResponse?.effectiveUrl;
        debugPrint('Uploaded featured image URL: $featuredImageUrl');
      }

      final tenderData = {
        'userId': userId,
        'projectName': projectNameController.text,
        'serviceType': serviceTypeController.text,
        'requirements': requirementsController.text,
        'budget': budget,
        'legalRequirements': legalRequirementsController.text,
        'startDate': Timestamp.fromDate(startDate.value!),
        'endDate': Timestamp.fromDate(endDate.value!),
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'stage': 'announced',
        'documentName': selectedFile.value?.files.single.name,
        'documentUrl': documentUrl,
        'featuredImageUrl': featuredImageUrl,
        'category': categoryController.text,
        'wilaya': wilayaController.text,
        'folderId': folderId.value ?? 'tenders/$userId',
        'offers': [],
      };

      if (projectId != null) {
        await firebaseService.firestore
            .collection('projects')
            .doc(projectId)
            .update(tenderData);
      } else {
        final docRef = await firebaseService.firestore
            .collection('projects')
            .add(tenderData);
        projectId = docRef.id;
      }

      Get.snackbar('success'.tr(), 'tender_published'.tr());
      Get.offAllNamed(Routes.DASHBOARD);
      debugPrint(
        'Sending notification to tender_updates: ${projectNameController.text}',
      );
      final contractors = await firebaseService.firestore
          .collection('users')
          .where('role', isEqualTo: 'contractor')
          .where('deviceToken', isNotEqualTo: null)
          .get();

      for (var doc in contractors.docs) {
        final deviceToken = doc.data()['deviceToken'] as String?;
        if (deviceToken != null && deviceToken.isNotEmpty) {
          debugPrint(
            'Sending notification to contractor: ${doc.id}, token: $deviceToken',
          );
          await firebaseService.sendNotification(
            deviceToken,
            'new_tender_published'.tr(),
            "${'tender_published_body'.tr()}: ${projectNameController.text}",

            /* data: {'tenderId': projectId}, */
          );
        }
      }
    } catch (e, stack) {
      debugPrint('Error announcing tender: $e');
      debugPrint(stack.toString());
      Get.snackbar('error'.tr(), 'publish_tender_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
