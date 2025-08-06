import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/offer_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class SubmitOffersController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;

  Future<void> submitOffer(
    String financialOffer,
    String technicalOffer,
    String duration,
    FilePickerResult? file,
  ) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null && file != null) {
        final fileUrl = await _firebaseService.uploadFile(
          File(file.files.single.path!),
          'tenders/${tender.id}/offers/${file.files.single.name}',
        );
        final offer = OfferModel(
          id: const Uuid().v4(),
          tenderId: tender.id,
          contractorId: FirebaseService().auth.currentUser?.uid ?? 'user_id',
          financialOffer: double.tryParse(financialOffer) ?? 0.0,
          technicalOffer: technicalOffer,
          duration: duration,
          documentUrl: fileUrl,
        );
        await _firebaseService.addOffer(offer);
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage3_${tender.id}',
            tenderId: tender.id,
            stageName: 'submit_offers',
            status: 'in_progress',
            details: {},
            startDate: DateTime.now(),
          ),
        );
        Get.snackbar('نجاح'.tr(), 'offer_submitted'.tr());
        Get.toNamed(Routes.OPEN_ENVLOPPES, arguments: tender);
      } else {
        Get.snackbar('خطأ'.tr(), 'يرجى ملء جميع الحقول'.tr());
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في تقديم العرض: $e'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
