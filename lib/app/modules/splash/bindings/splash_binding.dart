import 'package:get/get.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseService());
    Get.put(AuthController());
    Get.put(NotificationController());
    Get.put(SplashController());
  }
}
