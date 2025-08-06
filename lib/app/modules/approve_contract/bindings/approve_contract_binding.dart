import 'package:get/get.dart';

import '../controllers/approve_contract_controller.dart';

class ApproveContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApproveContractController>(
      () => ApproveContractController(),
    );
  }
}
