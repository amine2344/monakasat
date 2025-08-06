import 'package:get/get.dart';

import '../controllers/submit_offers_controller.dart';

class SubmitOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmitOffersController>(
      () => SubmitOffersController(),
    );
  }
}
