import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class ExecutionController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;

  Future<void> updateProgress(
    double progress,
    String report,
    FilePickerResult? file,
  ) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null) {
        final fileUrl = file != null
            ? await _firebaseService.uploadFile(
                File(file.files.single.path!),
                'tenders/${tender.id}/progress/${file.files.single.name}',
              )
            : null;
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage7_${tender.id}',
            tenderId: tender.id,
            stageName: 'execution_followup',
            status: progress == 1.0 ? 'completed' : 'in_progress',
            details: {
              'progress': progress,
              'report': report,
              'fileUrl': fileUrl,
            },
            startDate: DateTime.now(),
            endDate: progress == 1.0 ? DateTime.now() : null,
          ),
        );
        if (progress == 1.0) {
          Get.toNamed(Routes.FINAL_DELIVERY, arguments: tender);
        } else {
          Get.snackbar('نجاح'.tr(), 'تم تحديث التقدم'.tr());
        }
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في تحديث التقدم: $e'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
