import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/models/tender_stage_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class PlanningController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;

  Future<void> savePlanning(
    String projectName,
    String serviceType,
    String needs,
    String budget,
  ) async {
    try {
      isLoading.value = true;
      final tender = Get.arguments as TenderModel?;
      if (tender != null) {
        await _firebaseService.addTenderStage(
          TenderStageModel(
            id: 'stage1_${tender.id}',
            tenderId: tender.id,
            stageName: 'planning_needs',
            status: 'completed',
            details: {
              'projectName': projectName,
              'serviceType': serviceType,
              'needs': needs,
              'budget': budget,
            },
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
        Get.toNamed(Routes.ANNOUNCE, arguments: tender);
      }
    } catch (e) {
      Get.snackbar('خطأ'.tr(), 'فشل في حفظ البيانات'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
