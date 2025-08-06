import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/models/offer_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class OpenEnvelopesController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var offers = <OfferModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final tender = Get.arguments as TenderModel?;
    if (tender != null) {
      _firebaseService.getOffers(tender.id).listen((offerList) {
        offers.assignAll(offerList);
      });
    }
  }

  Future<void> generateReport() async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null) {
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage4_${tender.id}',
            tenderId: tender.id,
            stageName: 'open_envelopes',
            status: 'completed',
            details: {
              'report': 'Generated on ${DateTime.now().toIso8601String()}',
            },
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
        await _firebaseService.sendNotification(
          'tender_${tender.id}',
          'فتح الأظرفة'.tr(),
          'تم فتح الأظرفة للمناقصة: ${tender.title}'.tr(),
        );
        Get.toNamed(Routes.EVALUATE_OFFERS, arguments: tender);
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في إعداد المحضر'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
