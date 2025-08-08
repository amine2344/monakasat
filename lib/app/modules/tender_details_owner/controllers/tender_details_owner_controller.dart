import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

class TenderDetailsOwnerController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  late TenderModel tender;
  final offers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeTender();
    fetchOffers();
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

  void fetchOffers() {
    firebaseService.firestore
        .collection('projects')
        .doc(tender.id)
        .collection('offers')
        .snapshots()
        .listen((snapshot) {
          offers.assignAll(
            snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(),
          );
        });
  }

  Future<void> updateTenderStage(String stage) async {
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .update({'stage': stage, 'updatedAt': DateTime.now()});
      Get.snackbar('success'.tr(), 'tender_updated'.tr());
    } catch (e) {
      Get.snackbar('error'.tr(), 'update_tender_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOfferStatus(String offerId, String status) async {
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .doc(offerId)
          .update({'status': status});
      Get.snackbar(
        'success'.tr(),
        status == 'accepted' ? 'offer_accepted'.tr() : 'offer_rejected'.tr(),
      );
    } catch (e) {
      Get.snackbar('error'.tr(), 'update_offer_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
