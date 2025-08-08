import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class ApproveContractController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;

  Future<void> approveContract(FilePickerResult? file) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null && file != null) {
        final fileUrl = await _firebaseService.uploadFile(
          File(file.files.single.path!),
          'tenders/${tender.id}/contract/${file.files.single.name}',
        );
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage6_${tender.id}',
            tenderId: tender.id,
            stageName: 'approve_contract',
            status: 'completed',
            details: {'contractUrl': fileUrl},
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
        await _firebaseService.sendNotification(
          'tender_${tender.id}',
          'المصادقة على العقد'.tr(),
          'تمت المصادقة على العقد للمناقصة: ${tender.projectName}'.tr(),
        );
        Get.toNamed(Routes.EXECUTION, arguments: tender);
      } else {
        Get.snackbar('خطأ'.tr(), 'يرجى رفع العقد'.tr());
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في المصادقة على العقد: $e'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
