import 'package:get/get.dart';

import '../controllers/open_envloppes_controller.dart';

class OpenEnvloppesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpenEnvelopesController>(() => OpenEnvelopesController());
  }
}
