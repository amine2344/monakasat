import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dart:ui' as ui;

import '../../utils/theme_config.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  var currentLocale = 'ar'.obs;
  var textDirection = ui.TextDirection.rtl.obs; // Default to RTL for Arabic

  ThemeData get theme => isDarkMode.value ? darkTheme : lightTheme;

  final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    fontFamily: 'NotoKufiArabic',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleTextStyle: Get.textTheme.bodyLarge,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
    ),
    cardColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.black54),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    fontFamily: 'NotoKufiArabic',
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF303030),
      foregroundColor: Colors.white,
      titleTextStyle: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(color: Colors.white54, fontWeight: FontWeight.w400),
    ),
    cardColor: Colors.grey[800],
    iconTheme: const IconThemeData(color: Colors.white54),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
  );

  @override
  void onInit() {
    super.onInit();
    loadThemePreference();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    saveThemePreference();
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }

  Future<void> loadLocalePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'ar';
    currentLocale.value = languageCode;
    textDirection.value = languageCode == 'ar'
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;
  }

  Future<void> saveLocalePreference(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    currentLocale.value = locale.languageCode;
    textDirection.value = locale.languageCode == 'ar'
        ? ui.TextDirection.rtl
        : ui.TextDirection.ltr;
    final context = Get.context;
    if (context != null) {
      final supportedLocales =
          EasyLocalization.of(context)?.supportedLocales ??
          [const Locale('ar')];
      if (supportedLocales.contains(locale)) {
        await EasyLocalization.of(context)?.setLocale(locale);
        Get.updateLocale(locale);
      } else {
        await EasyLocalization.of(context)?.setLocale(const Locale('ar'));
        Get.updateLocale(const Locale('ar'));
        currentLocale.value = 'ar';
        textDirection.value = ui.TextDirection.rtl;
      }
    }
  }
}
