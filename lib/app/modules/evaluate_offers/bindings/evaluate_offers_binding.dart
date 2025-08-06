import 'package:get/get.dart';

import '../controllers/evaluate_offers_controller.dart';

class EvaluateOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EvaluateOffersController>(
      () => EvaluateOffersController(),
    );
  }
}
