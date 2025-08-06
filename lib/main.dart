import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:firebase_core/firebase_core.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'app/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  final themeController = ThemeController();
  Get.put(themeController);
  await themeController.loadThemePreference();
  await themeController.loadLocalePreference(); // Load locale before runApp

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('fr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      useOnlyLangCode: true,
      startLocale:
          await _getSavedLocale(), // Set initial locale from shared_preferences
      child: MounakassatApp(themeController: themeController),
    ),
  );
}

Future<Locale> _getSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language_code') ?? 'ar';
  return Locale(languageCode);
}

class MounakassatApp extends StatelessWidget {
  final ThemeController themeController;

  const MounakassatApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'app_title'.tr(),
      debugShowCheckedModeBanner: false,
      theme: themeController.theme,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) {
        return Obx(
          () => Directionality(
            textDirection: themeController.textDirection.value,
            child: child ?? Container(),
          ),
        );
      },
    );
  }
}
