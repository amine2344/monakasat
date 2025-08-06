import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../../utils/theme_config.dart';
import '../controllers/dashboard_controller.dart';

class CustomDrawer extends StatelessWidget {
  final DashboardController controller = Get.find();

  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Text(
              'app_title'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'NotoKufiArabic',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'home'.tr(),
              style: const TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              controller.changeTab(0);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(
              'dashboard'.tr(),
              style: const TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              controller.changeTab(1);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: Text(
              'my_offers'.tr(),
              style: const TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              controller.changeTab(2);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'settings'.tr(),
              style: const TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              controller.changeTab(3);
              Get.back();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.subscriptions),
            title: const Text(
              'باقات الإشتراك',
              style: TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              Get.toNamed('/subscription');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text(
              'تسجيل الدخول',
              style: TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              Get.toNamed('/auth');
            },
          ),
          /* ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text(
              'إنشاء حساب',
              style: TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            onTap: () {
              Get.toNamed('/signup');
            },
          ), */
        ],
      ),
    );
  }
}
