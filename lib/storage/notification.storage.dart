import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

class NotificationStorage {
  static final NotificationStorage _instance = NotificationStorage._internal();
  factory NotificationStorage() => _instance;
  NotificationStorage._internal();

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveNotification(
    String userId,
    Map<String, dynamic> notification,
  ) async {
    try {
      final prefs = await _getPrefs();
      final key = 'notifications_$userId';
      final List<String> storedNotifications = prefs.getStringList(key) ?? [];
      storedNotifications.add(jsonEncode(notification));
      await prefs.setStringList(key, storedNotifications);
      debugPrint(
        'Notification saved for user $userId: ${notification['title']}',
      );
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_save_notification'.tr());
      debugPrint('Error saving notification: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final prefs = await _getPrefs();
      final key = 'notifications_$userId';
      final List<String> storedNotifications = prefs.getStringList(key) ?? [];
      return storedNotifications
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList()
        ..sort(
          (a, b) =>
              (b['receivedAt'] as String).compareTo(a['receivedAt'] as String),
        );
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      final prefs = await _getPrefs();
      final key = 'notifications_$userId';
      final List<String> storedNotifications = prefs.getStringList(key) ?? [];
      final updatedNotifications = storedNotifications.map((item) {
        final notification = jsonDecode(item) as Map<String, dynamic>;
        if (notification['id'] == notificationId) {
          notification['read'] = true;
        }
        return jsonEncode(notification);
      }).toList();
      await prefs.setStringList(key, updatedNotifications);
      debugPrint('Notification marked as read: $notificationId');
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_mark_notification_read'.tr());
      debugPrint('Error marking notification as read: $e');
    }
  }
}
