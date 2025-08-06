import 'package:get/get.dart';

import '../controllers/planning_controller.dart';

class PlanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanningController>(
      () => PlanningController(),
    );
  }
}
