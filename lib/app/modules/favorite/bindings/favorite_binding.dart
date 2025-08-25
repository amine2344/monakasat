import 'package:get/get.dart';
import 'package:mounakassat_dz/app/modules/home/controllers/home_controller.dart';

import '../controllers/favorite_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(() => FavoriteController());
    Get.put(HomeController());
  }
}
