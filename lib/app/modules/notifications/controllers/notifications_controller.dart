import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/main.dart';
import '../../../../storage/notification.storage.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class NotificationController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  final NotificationStorage notificationStorage = NotificationStorage();
  final notifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupForegroundNotifications();
    fetchNotifications();
  }

  void setupForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
      saveNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationTap(message);
    });
  }

  void saveNotification(RemoteMessage message) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) return;

    final notification = {
      'id':
          message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'receivedAt': DateTime.now().toIso8601String(),
      'read': false,
      'data': message.data,
    };

    await notificationStorage.saveNotification(userId, notification);
    fetchNotifications();
  }

  void fetchNotifications() async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null) {
      isLoading.value = true;
      final fetchedNotifications = await notificationStorage.getNotifications(
        userId,
      );
      notifications.assignAll(fetchedNotifications);
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) return;

    await notificationStorage.markAsRead(userId, notificationId);
    fetchNotifications();
  }

  void handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    if (data.containsKey('tenderId')) {
      final tenderId = data['tenderId'];
      final isProjectOwner =
          authController.selectedRole.value == 'project_owner';
      Get.toNamed(
        isProjectOwner
            ? Routes.TENDER_DETAILS_OWNER
            : Routes.TENDER_DETAILS_CONTRACTOR,
        arguments: {'tenderId': tenderId},
      );
    }
  }
}
