import 'package:get/get.dart';

import '../controllers/final_delivery_controller.dart';

class FinalDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalDeliveryController>(
      () => FinalDeliveryController(),
    );
  }
}
