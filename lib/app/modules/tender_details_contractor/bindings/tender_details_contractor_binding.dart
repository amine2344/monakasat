import 'package:get/get.dart';

import '../controllers/tender_details_contractor_controller.dart';

class TenderDetailsContractorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenderDetailsContractorController>(
      () => TenderDetailsContractorController(),
    );
  }
}
