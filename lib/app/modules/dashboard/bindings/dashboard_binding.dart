import 'package:get/get.dart';
import 'package:mounakassat_dz/app/data/services/firebase_service.dart';
import 'package:mounakassat_dz/app/modules/notifications/controllers/notifications_controller.dart';

import '../../auth/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';

import 'package:mounakassat_dz/app/modules/my_offers/controllers/my_offers_controller.dart';
import 'package:mounakassat_dz/app/modules/profile/controllers/profile_controller.dart';
import 'package:mounakassat_dz/app/modules/settings/controllers/settings_controller.dart';

import '../../home/controllers/home_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(SettingsController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<FirebaseService>(() => FirebaseService());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<MyOffersController>(() => MyOffersController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
