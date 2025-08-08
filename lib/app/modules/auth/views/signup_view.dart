import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';

import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/auth_controller.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  static const List<String> wilayas = [
    'Adrar',
    'Chlef',
    'Laghouat',
    'Oum El Bouaghi',
    'Batna',
    'Béjaïa',
    'Biskra',
    'Béchar',
    'Blida',
    'Bouira',
    'Tamanrasset',
    'Tébessa',
    'Tlemcen',
    'Tiaret',
    'Tizi Ouzou',
    'Alger',
    'Djelfa',
    'Jijel',
    'Sétif',
    'Saïda',
    'Skikda',
    'Sidi Bel Abbès',
    'Annaba',
    'Guelma',
    'Constantine',
    'Médéa',
    'Mostaganem',
    'M’Sila',
    'Mascara',
    'Ouargla',
    'Oran',
    'El Bayadh',
    'Illizi',
    'Bordj Bou Arréridj',
    'Boumerdès',
    'El Tarf',
    'Tindouf',
    'Tissemsilt',
    'El Oued',
    'Khenchela',
    'Souk Ahras',
    'Tipaza',
    'Mila',
    'Aïn Defla',
    'Naâma',
    'Aïn Témouchent',
    'Ghardaïa',
    'Relizane',
  ];

  static const List<String> activitySectors = [
    'Construction',
    'Engineering',
    'Transportation',
    'Energy',
    'IT Services',
    'Consulting',
    'Manufacturing',
    'Agriculture',
    'Healthcare',
    'Education',
  ];

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: controller.email.value);
    final phoneController = TextEditingController(text: controller.phone.value);
    final passwordController = TextEditingController(
      text: controller.password.value,
    );
    final confirmPasswordController = TextEditingController(
      text: controller.confirmPassword.value,
    );
    final nameController = TextEditingController(text: controller.name.value);
    final prenameController = TextEditingController(
      text: controller.prename.value,
    );
    final wilayaController = TextEditingController(
      text: controller.wilaya.value,
    );
    final activitySectorController = TextEditingController(
      text: controller.activitySector.value,
    );
    final companyNameController = TextEditingController(
      text: controller.companyName.value,
    );
    final companyAddressController = TextEditingController(
      text: controller.companyAddress.value,
    );
    final companyPhoneController = TextEditingController(
      text: controller.companyPhone.value,
    );

    String? validate(String? value, String field) {
      switch (field) {
        case 'email':
          if (value == null || value.isEmpty) return 'please_enter_email'.tr();
          if (!GetUtils.isEmail(value)) return 'invalid_email'.tr();
          return null;
        case 'phone':
          if (value == null || value.isEmpty) return 'please_enter_phone'.tr();
          return null;
        case 'password':
          if (value == null || value.isEmpty)
            return 'please_enter_password'.tr();
          if (value.length < 6) return 'password_too_short'.tr();
          return null;
        case 'confirm_password':
          if (value == null || value.isEmpty)
            return 'please_confirm_password'.tr();
          if (value != passwordController.text)
            return 'passwords_do_not_match'.tr();
          return null;
        case 'name':
          if (value == null || value.isEmpty) return 'please_enter_name'.tr();
          return null;
        case 'prename':
          if (value == null || value.isEmpty)
            return 'please_enter_prename'.tr();
          return null;
        case 'wilaya':
          if (value == null || value.isEmpty)
            return 'please_select_wilaya'.tr();
          return null;
        case 'activity_sector':
          if (value == null || value.isEmpty)
            return 'please_select_activity_sector'.tr();
          return null;
        default:
          return null;
      }
    }

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          'signup'.tr(),
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
              child: Obx(
                () => Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        controller.currentStep.value == 1
                            ? 'signup_step1'.tr()
                            : 'signup_step2'.tr(),
                        style: const TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (controller.currentStep.value == 1) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: Center(child: Text('contractor'.tr())),
                                selected:
                                    controller.selectedRole.value ==
                                    'contractor',
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
                                label: Center(
                                  child: Text('project_owner'.tr()),
                                ),
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
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: emailController,
                          labelText: 'email'.tr(),
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => validate(value, 'email'),
                          onChanged: (value) => validate(value, 'email'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: phoneController,
                          labelText: 'phone'.tr(),
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) => validate(value, 'phone'),
                          onChanged: (value) => validate(value, 'phone'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'password'.tr(),
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          validator: (value) => validate(value, 'password'),
                          onChanged: (value) => validate(value, 'password'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'confirm_password'.tr(),
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          validator: (value) =>
                              validate(value, 'confirm_password'),
                          onChanged: (value) =>
                              validate(value, 'confirm_password'),
                        ),
                      ] else if (controller.selectedRole.value ==
                          'contractor') ...[
                        CustomTextField(
                          controller: nameController,
                          labelText: 'name'.tr(),
                          prefixIcon: Icons.person,
                          validator: (value) => validate(value, 'name'),
                          onChanged: (value) => validate(value, 'name'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: prenameController,
                          labelText: 'prename'.tr(),
                          prefixIcon: Icons.person,
                          validator: (value) => validate(value, 'prename'),
                          onChanged: (value) => validate(value, 'prename'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: wilayaController,
                          labelText: 'wilaya'.tr(),
                          prefixIcon: Icons.location_city,
                          isDropdown: true,
                          onTap: () => _showSelectionDialog(
                            context,
                            wilayas,
                            'wilaya',
                            (value) {
                              wilayaController.text = value;
                              controller.wilaya.value = value;
                              controller.wilaya.refresh();
                            },
                          ),
                          validator: (value) => validate(value, 'wilaya'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: activitySectorController,
                          labelText: 'activity_sector'.tr(),
                          prefixIcon: Icons.work,
                          isDropdown: true,
                          onTap: () => _showSelectionDialog(
                            context,
                            activitySectors,
                            'activity_sector',
                            (value) {
                              activitySectorController.text = value;
                              controller.activitySector.value = value;
                              controller.activitySector.refresh();
                            },
                          ),
                          validator: (value) =>
                              validate(value, 'activity_sector'),
                        ),
                      ] else ...[
                        CustomTextField(
                          controller: companyNameController,
                          labelText: 'company_name'.tr(),
                          prefixIcon: Icons.business,
                          validator: (value) => validate(value, 'company_name'),
                          onChanged: (value) => validate(value, 'company_name'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: companyAddressController,
                          labelText: 'company_address'.tr(),
                          prefixIcon: Icons.location_on,
                          validator: (value) =>
                              validate(value, 'company_address'),
                          onChanged: (value) =>
                              validate(value, 'company_address'),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: companyPhoneController,
                          labelText: 'company_phone'.tr(),
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              validate(value, 'company_phone'),
                          onChanged: (value) =>
                              validate(value, 'company_phone'),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: controller.currentStep.value != 1
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          if (controller.currentStep.value > 1)
                            TextButton(
                              onPressed: controller.previousStep,
                              child: Text(
                                'previous'.tr(),
                                style: const TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          CustomButton(
                            text: controller.currentStep.value == 1
                                ? 'next'.tr()
                                : 'signup'.tr(),
                            trailingIcon: controller.currentStep.value == 1
                                ? Icons.arrow_forward
                                : Icons.person_add,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: controller.currentStep.value != 1
                                ? Size(50.w, 8.h)
                                : Size(70.w, 8.h),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            borderRadius: 8,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (controller.currentStep.value == 1) {
                                  controller.email.value = emailController.text;
                                  controller.phone.value = phoneController.text;
                                  controller.password.value =
                                      passwordController.text;
                                  controller.confirmPassword.value =
                                      confirmPasswordController.text;
                                  controller.nextStep();
                                } else {
                                  if (controller.selectedRole.value ==
                                      'contractor') {
                                    controller.name.value = nameController.text;
                                    controller.prename.value =
                                        prenameController.text;
                                    controller.wilaya.value =
                                        wilayaController.text;
                                    controller.activitySector.value =
                                        activitySectorController.text;
                                    if (controller.name.value.isEmpty ||
                                        controller.prename.value.isEmpty ||
                                        controller.wilaya.value.isEmpty ||
                                        controller
                                            .activitySector
                                            .value
                                            .isEmpty) {
                                      Get.snackbar(
                                        'error'.tr(),
                                        'please_fill_all_fields'.tr(),
                                      );
                                      return;
                                    }
                                  } else {
                                    controller.companyName.value =
                                        companyNameController.text;
                                    controller.companyAddress.value =
                                        companyAddressController.text;
                                    controller.companyPhone.value =
                                        companyPhoneController.text;
                                  }
                                  controller.signUp();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.AUTH),
                        child: Text(
                          'login'.tr(),
                          style: const TextStyle(
                            fontFamily: 'NotoKufiArabic',
                            color: primaryColor,
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
      ),
    );
  }

  void _showSelectionDialog(
    BuildContext context,
    List<String> items,
    String titleKey,
    Function(String) onSelected,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          titleKey.tr(),
          style: const TextStyle(fontFamily: 'NotoKufiArabic'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map(
                  (item) => ListTile(
                    title: Text(
                      item,
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    onTap: () {
                      onSelected(item);
                      Get.back();
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr(),
              style: const TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
          ),
        ],
      ),
    );
  }
}
