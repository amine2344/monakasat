import 'package:get/get.dart';

import '../controllers/tender_details_owner_controller.dart';

class TenderDetailsOwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderDetailsOwnerController>(
      () => TenderDetailsOwnerController(),
    );
  }
}
