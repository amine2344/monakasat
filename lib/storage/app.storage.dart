import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

import '../app/data/models/user_model.dart';

class AppStorage {
  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;
  AppStorage._internal();

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveUser(String userId, UserModel user) async {
    try {
      final prefs = await _getPrefs();
      final key = 'user_$userId';
      await prefs.setString(key, jsonEncode(user.toJson()));
      debugPrint('User saved to SharedPreferences: ${user.email}');
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_save_user'.tr());
      debugPrint('Error saving user to SharedPreferences: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final prefs = await _getPrefs();
      final key = 'user_$userId';
      final userJson = prefs.getString(key);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap, userId);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user from SharedPreferences: $e');
      return null;
    }
  }

  Future<void> clearUser(String userId) async {
    try {
      final prefs = await _getPrefs();
      final key = 'user_$userId';
      await prefs.remove(key);
      debugPrint('User cleared from SharedPreferences: $userId');
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_clear_user'.tr());
      debugPrint('Error clearing user from SharedPreferences: $e');
    }
  }
}
