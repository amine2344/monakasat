import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';

import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          'login'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            color: Get.theme.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'welcome'.tr(),
                      style: const TextStyle(
                        fontFamily: 'NotoKufiArabic',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: Center(child: Text('contractor'.tr())),
                              selected:
                                  controller.selectedRole.value == 'contractor',
                              selectedColor: primaryColor,
                              labelStyle: TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                color:
                                    controller.selectedRole.value ==
                                        'contractor'
                                    ? Colors.white
                                    : Colors.blueGrey,
                              ),
                              onSelected: (selected) {
                                if (selected)
                                  controller.selectRole('contractor');
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: Center(child: Text('project_owner'.tr())),
                              selected:
                                  controller.selectedRole.value ==
                                  'project_owner',
                              selectedColor: primaryColor,
                              labelStyle: TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                color:
                                    controller.selectedRole.value ==
                                        'project_owner'
                                    ? Colors.white
                                    : Colors.blueGrey,
                              ),
                              onSelected: (selected) {
                                if (selected)
                                  controller.selectRole('project_owner');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: emailController,
                      labelText: 'email'.tr(),
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_email'.tr();
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'invalid_email'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        controller: passwordController,
                        labelText: 'password'.tr(),

                        prefixIcon: Icons.lock,
                        obscureText: controller.isPasswordHide.value,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: IconButton(
                            icon: Icon(
                              !controller.isPasswordHide.value
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                            ),
                            onPressed: controller.togglePassHide,
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please_enter_password'.tr();
                          }
                          if (value.length < 6) {
                            return 'password_too_short'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                color: primaryColor,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                }
                              },
                              child: Text(
                                'login'.tr(),
                                style: const TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.SIGNUP),
                      child: Center(
                        child: Text(
                          'create_account'.tr(),
                          style: const TextStyle(
                            fontFamily: 'NotoKufiArabic',
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
