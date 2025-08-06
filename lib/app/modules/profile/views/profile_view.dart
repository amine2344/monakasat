import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اسم الشركة: ${controller.userData['companyName'] ?? 'غير متوفر'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'البريد الإلكتروني: ${controller.userData['email'] ?? 'غير متوفر'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'الباقة: ${controller.userData['subscription'] ?? 'مجانية'}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(
                  themeController.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                title: Text(
                  themeController.isDarkMode.value
                      ? 'الوضع الفاتح'
                      : 'الوضع الداكن',
                ),
                onTap: () => themeController.toggleTheme(),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: controller.signOut,
                  child: const Text('تسجيل الخروج'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
