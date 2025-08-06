import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';

import 'package:mounakassat_dz/app/modules/my_offers/controllers/my_offers_controller.dart';
import 'package:mounakassat_dz/app/modules/profile/controllers/profile_controller.dart';
import 'package:mounakassat_dz/app/modules/settings/controllers/settings_controller.dart';

import '../../home/controllers/home_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    Get.put(SettingsController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<MyOffersController>(() => MyOffersController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
