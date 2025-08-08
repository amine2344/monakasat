import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/main.dart';

import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class NotificationController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
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
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'receivedAt': DateTime.now(),
      'read': false,
      'data': message.data,
    };

    try {
      await firebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification);
      print('Notification saved: ${notification['title']}');
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_save_notification'.tr());
    }
  }

  void fetchNotifications() {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null) {
      isLoading.value = true;
      firebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('receivedAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            notifications.assignAll(
              snapshot.docs
                  .map((doc) => {...doc.data(), 'id': doc.id})
                  .toList(),
            );
            isLoading.value = false;
          });
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) return;

    try {
      await firebaseService.firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
      print('Notification marked as read: $notificationId');
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_mark_notification_read'.tr());
    }
  }

  void handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    if (data.containsKey('tenderId')) {
      final tenderId = data['tenderId'];
      final isProjectOwner =
          authController.selectedRole.value == 'project_owner';
      Get.toNamed(
        isProjectOwner ? '/tender_details_owner' : '/tender_details_contractor',
        arguments: {
          'tenderId': tenderId,
        }, // Fetch tender details in the target view
      );
    }
  }
}
