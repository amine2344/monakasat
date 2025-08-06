import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var tender = Rxn<TenderModel>();
  var stages = <TenderStageModel>[].obs;
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tender.value = Get.arguments as TenderModel?;
    if (tender.value != null) {
      fetchStages(tender.value!.id);
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void fetchStages(String tenderId) {
    _firebaseService.getTenderStages(tenderId).listen((stageList) {
      stages.assignAll(stageList);
    });
  }

  Future<void> updateStageStatus(
    String stageId,
    String status,
    Map<String, dynamic> details,
  ) async {
    isLoading.value = true;
    try {
      await _firebaseService.addTenderStage(
        TenderStageModel(
          id: stageId,
          tenderId: tender.value!.id,
          stageName: stages
              .firstWhere((stage) => stage.id == stageId)
              .stageName,
          status: status,
          details: details,
          startDate: DateTime.now(),
          endDate: status == 'completed' ? DateTime.now() : null,
        ),
      );
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في تحديث حالة المرحلة: $e'.tr());
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToStage(TenderStageModel stage) {
    if (tender.value == null) return;

    switch (stage.stageName) {
      case 'planning_needs':
        Get.toNamed(Routes.PLANNING, arguments: tender.value);
        break;
      case 'announce_tender':
        Get.toNamed(Routes.ANNOUNCE, arguments: tender.value);
        break;
      case 'submit_offers':
        Get.toNamed(Routes.SUBMIT_OFFERS, arguments: tender.value);
        break;
      case 'open_envelopes':
        Get.toNamed(Routes.OPEN_ENVLOPPES, arguments: tender.value);
        break;
      case 'evaluate_offers':
        Get.toNamed(Routes.EVALUATE_OFFERS, arguments: tender.value);
        break;
      case 'approve_contract':
        Get.toNamed(Routes.APPROVE_CONTRACT, arguments: tender.value);
        break;
      case 'execution_followup':
        Get.toNamed(Routes.EXECUTION, arguments: tender.value);
        break;
      case 'final_delivery':
        Get.toNamed(Routes.FINAL_DELIVERY, arguments: tender.value);
        break;
      default:
        Get.snackbar('خطأ'.tr(), 'مرحلة غير معروفة'.tr());
    }
  }
}
