import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class AnnounceController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  Future<void> announceTender(
    String legalRequirements,
    FilePickerResult? file,
  ) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null &&
          file != null &&
          startDate.value != null &&
          endDate.value != null) {
        final fileUrl = await _firebaseService.uploadFile(
          File(file.files.single.path!),
          'tenders/${tender.id}/documents/${file.files.single.name}',
        );
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage2_${tender.id}',
            tenderId: tender.id,
            stageName: 'announce_tender',
            status: 'completed',
            details: {
              'legalRequirements': legalRequirements,
              'documentUrl': fileUrl,
              'startDate': startDate.value!.toIso8601String(),
              'endDate': endDate.value!.toIso8601String(),
            },
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
        await _firebaseService.sendNotification(
          'tender_${tender.id}',
          'إعلان مناقصة جديدة'.tr(),
          'تم الإعلان عن مناقصة جديدة: ${tender.title}'.tr(),
        );
        Get.toNamed(Routes.SUBMIT_OFFERS, arguments: tender);
      } else {
        Get.snackbar('خطأ'.tr(), 'يرجى ملء جميع الحقول'.tr());
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في نشر الإعلان: $e'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
