import 'package:get/get.dart';

import '../controllers/my_offers_controller.dart';

class MyOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOffersController>(
      () => MyOffersController(),
    );
  }
}
