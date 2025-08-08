import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class MyOffersController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final AuthController _authController = Get.find<AuthController>();
  var myOffers = <TenderModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyOffers();
  }

  void fetchMyOffers() {
    final user = _firebaseService.auth.currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }

    final isProjectOwner =
        _authController.selectedRole.value == 'project_owner';
    _firebaseService.getTenders().listen((tenderList) {
      /* myOffers.assignAll(
        isProjectOwner
            ? tenderList
                  .where((tender) => tender.announcer == user.email)
                  .toList()
            : tenderList.where((tender) {
                final offers = tender. ?? [];
                return tender.isOpen ||
                    offers.any((offer) => offer['contractorId'] == user.uid);
              }).toList(),
      ); */
      isLoading.value = false;
    });
  }

  void trackInteraction(String tenderId, String action) async {
    final user = _firebaseService.auth.currentUser;
    if (user == null) return;

    try {
      await _firebaseService.firestore.collection('interactions').add({
        'userId': user.uid,
        'tenderId': tenderId,
        'action': action,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error tracking interaction: $e');
    }
  }

  String getStageText(String stage) {
    switch (stage) {
      case 'planning':
        return 'planning_stage'.tr();
      case 'announcement':
        return 'tender_announcement'.tr();
      case 'submission':
        return 'offer_submission'.tr();
      case 'opening':
        return 'opening_envelopes'.tr();
      case 'evaluation':
        return 'offer_evaluation'.tr();
      case 'approval':
        return 'contract_approval'.tr();
      case 'execution':
        return 'execution_monitoring'.tr();
      case 'delivery':
        return 'final_delivery'.tr();
      default:
        return 'unknown_stage'.tr();
    }
  }
}
