import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initializeFirebaseMessaging();
    navigateToNextScreen();
  }

  Future<void> initializeFirebaseMessaging() async {
    try {
      debugPrint("RUNNING INITIALISATION");
      await FirebaseMessaging.instance.requestPermission();
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: $token');
      final initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        try {
          final controller = Get.find<NotificationController>();
          controller.handleNotificationTap(initialMessage);
        } catch (e) {
          debugPrint('Error accessing NotificationController: $e');
        }
      }
    } catch (e) {
      debugPrint('Error initializing Firebase Messaging: $e');
    }
  }

  Future<void> navigateToNextScreen() async {
    debugPrint("GETTING USER...");
    try {
      final firebaseService = Get.find<FirebaseService>();
      final authController = Get.find<AuthController>();
      final isLoggedIn = firebaseService.auth.currentUser != null;

      if (isLoggedIn) {
        debugPrint("USER FOUND, LOADING DATA...");
        await authController.loadUserData();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint("NAVIGATING TO HOME");
          Get.offNamed(Routes.DASHBOARD);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint("NO USER, NAVIGATING TO AUTH");
          //Get.offNamed(Routes.AUTH);
          Get.offNamed(Routes.DASHBOARD);
        });
      }
    } catch (e) {
      debugPrint('Error in navigateToNextScreen: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Failed to initialize app, redirecting to login');
        //Get.offNamed(Routes.AUTH);
        Get.offNamed(Routes.DASHBOARD);
      });
    }
  }
}
