import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';

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
      appBar: CustomAppBar(
        titleText: 'settings'.tr(),
        automaticallyImplyLeading: true,
        centerTitle: false,
      ),
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Settings Section
              _buildSectionHeader('app_settings'.tr()),
              _buildSettingsCard(
                children: [
                  _buildSettingsItem(
                    icon: Icons.language,
                    title: 'language'.tr(),
                    trailing: DropdownButton<Locale>(
                      value: context.locale,
                      underline: Container(),
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
                                style: const TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                ),
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
                  ),
                  const Divider(height: 1),
                  Obx(
                    () => _buildSettingsItem(
                      icon: themeController.isDarkMode.value
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      title: 'theme'.tr(),
                      trailing: Switch(
                        value: themeController.isDarkMode.value,
                        activeColor: primaryColor,
                        onChanged: (value) {
                          themeController.toggleTheme();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Account Section
              _buildSectionHeader('account'.tr()),
              _buildSettingsCard(
                children: [
                  _buildSettingsItem(
                    icon: Icons.logout,
                    title: 'logout'.tr(),
                    onTap: () async {
                      await authController.firebaseService.signOut();
                      Get.offAllNamed('/login');
                    },
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // App Info Section
              _buildSectionHeader('about_app'.tr()),
              _buildSettingsCard(
                children: [
                  _buildSettingsItem(
                    icon: Icons.info_outline,
                    title: 'version'.tr(),
                    trailing: Text(
                      '1.0.0', // Replace with your actual version
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: 'NotoKufiArabic',
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'privacy_policy'.tr(),
                    onTap: () {
                      // Add privacy policy navigation
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'NotoKufiArabic',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 0,
      color: Get.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? primaryColor),
      title: Text(
        title,
        style: TextStyle(fontFamily: 'NotoKufiArabic', color: textColor),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 24,
    );
  }
}
