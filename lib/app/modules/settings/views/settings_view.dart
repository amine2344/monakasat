import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'language'.tr(),
                style: const TextStyle(
                  fontFamily: 'NotoKufiArabic',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Locale>(
                decoration: InputDecoration(
                  labelText: 'select_language'.tr(),
                  border: const OutlineInputBorder(),
                ),
                value: context.locale,
                items: const [Locale('ar'), Locale('fr'), Locale('en')]
                    .map(
                      (locale) => DropdownMenuItem(
                        value: locale,
                        child: Text(
                          locale.languageCode == 'ar'
                              ? 'arabic'.tr()
                              : locale.languageCode == 'fr'
                              ? 'french'.tr()
                              : 'english'.tr(),
                          style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (locale) {
                  if (locale != null) {
                    themeController.saveLocalePreference(locale);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'theme'.tr(),
                style: const TextStyle(
                  fontFamily: 'NotoKufiArabic',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    themeController.isDarkMode.value
                        ? 'dark_mode'.tr()
                        : 'light_mode'.tr(),
                    style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                  ),
                  value: themeController.isDarkMode.value,
                  onChanged: (value) {
                    themeController.toggleTheme();
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await authController.firebaseService.signOut();
                  Get.offAllNamed('/login');
                },
                child: Text(
                  'logout'.tr(),
                  style: const TextStyle(
                    fontFamily: 'NotoKufiArabic',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
