import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/models/offer_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class EvaluateOffersController extends GetxController {
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

  Future<void> evaluateOffer(String offerId, String score) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null) {
        await FirebaseFirestore.instance
            .collection('offers')
            .doc(offerId)
            .update({'score': double.tryParse(score) ?? 0.0, 'isWinner': true});
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage5_${tender.id}',
            tenderId: tender.id,
            stageName: 'evaluate_offers',
            status: 'completed',
            details: {'winnerOfferId': offerId, 'score': score},
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
        await _firebaseService.sendNotification(
          'tender_${tender.id}',
          'تقييم العروض'.tr(),
          'تم اختيار الفائز للمناقصة: ${tender.title}'.tr(),
        );
        Get.toNamed(Routes.APPROVE_CONTRACT, arguments: tender);
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في تقييم العرض'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
