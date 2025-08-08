import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import '../../../data/services/firebase_service.dart';

class PlanningController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  var isLoading = false.obs;
  var currentStep = 1.obs;
  var projectName = ''.obs;
  var serviceType = ''.obs;
  var requirements = ''.obs;
  var budget = 0.0.obs;

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      Get.toNamed(
        Routes.ANNOUNCE,
        arguments: {
          'projectName': projectName.value,
          'serviceType': serviceType.value,
          'requirements': requirements.value,
          'budget': budget.value,
        },
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      Get.back();
    }
  }

  Future<void> saveProjectDetails({
    required String projectName,
    required String serviceType,
    required String requirements,
    required double budget,
  }) async {
    this.projectName.value = projectName;
    this.serviceType.value = serviceType;
    this.requirements.value = requirements;
    this.budget.value = budget;
    nextStep();
  }

  Future<void> updateProjectDetails({
    required String projectId,
    required String projectName,
    required String serviceType,
    required String requirements,
    required double budget,
  }) async {
    isLoading.value = true;
    try {
      final userId = firebaseService.auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
        return;
      }
      await firebaseService.firestore
          .collection('projects')
          .doc(projectId)
          .update({
            'projectName': projectName,
            'serviceType': serviceType,
            'requirements': requirements,
            'budget': budget,
            'updatedAt': DateTime.now(),
          });
      Get.snackbar('success'.tr(), 'project_updated'.tr());
      Get.toNamed(
        Routes.ANNOUNCE,
        arguments: {
          'projectId': projectId,
          'projectName': projectName,
          'serviceType': serviceType,
          'requirements': requirements,
          'budget': budget,
        },
      );
    } catch (e) {
      Get.snackbar('error'.tr(), 'update_project_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
