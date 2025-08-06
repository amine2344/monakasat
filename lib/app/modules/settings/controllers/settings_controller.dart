import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/theme_controller.dart';

class SettingsController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();
  var selectedLanguage = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    Get.updateLocale(
      Locale(
        languageCode,
        languageCode == 'ar'
            ? 'DZ'
            : languageCode == 'fr'
            ? 'FR'
            : 'US',
      ),
    );
    savePreferences();
  }

  void toggleTheme() {
    themeController.toggleTheme();
    savePreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLanguage.value = prefs.getString('language') ?? 'ar';
    Get.updateLocale(
      Locale(
        selectedLanguage.value,
        selectedLanguage.value == 'ar'
            ? 'DZ'
            : selectedLanguage.value == 'fr'
            ? 'FR'
            : 'US',
      ),
    );
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', selectedLanguage.value);
    await prefs.setBool('isDarkMode', themeController.isDarkMode.value);
  }
}
