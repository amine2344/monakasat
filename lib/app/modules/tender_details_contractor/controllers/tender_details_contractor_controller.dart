import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class TenderDetailsContractorController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  late TenderModel tender;
  final userOffer = Rx<Map<String, dynamic>?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeTender();
    fetchUserOffer();
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

  void fetchUserOffer() {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null) {
      firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .where('contractorId', isEqualTo: userId)
          .snapshots()
          .listen((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              userOffer.value = {
                ...snapshot.docs.first.data(),
                'id': snapshot.docs.first.id,
              };
            } else {
              userOffer.value = null;
            }
          });
    }
  }

  Future<void> submitOffer(String offerAmount, String offerDetails) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
      return;
    }
    isLoading.value = true;
    try {
      await firebaseService.firestore
          .collection('projects')
          .doc(tender.id)
          .collection('offers')
          .add({
            'contractorId': userId,
            'contractorName': authController.user.value?.name,
            'offerAmount': double.parse(offerAmount),
            'offerDetails': offerDetails,
            'submittedAt': DateTime.now(),
            'status': 'pending',
          });
      Get.snackbar('success'.tr(), 'offer_submitted'.tr());
    } catch (e) {
      Get.snackbar('error'.tr(), 'submit_offer_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
