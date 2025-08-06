import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class FinalDeliveryController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;

  Future<void> completeDelivery(
    String evaluation,
    double rating,
    FilePickerResult? file,
  ) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null) {
        final fileUrl = file != null
            ? await _firebaseService.uploadFile(
                File(file.files.single.path!),
                'tenders/${tender.id}/delivery/${file.files.single.name}',
              )
            : null;
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage8_${tender.id}',
            tenderId: tender.id,
            stageName: 'final_delivery',
            status: 'completed',
            details: {
              'evaluation': evaluation,
              'rating': rating,
              'fileUrl': fileUrl,
            },
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
        Get.snackbar('نجاح'.tr(), 'تم إكمال الاستلام النهائي'.tr());
        Get.toNamed(Routes.DASHBOARD, arguments: tender);
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في إكمال الاستلام: $e'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
