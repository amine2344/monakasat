import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
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

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text('signup'.tr(), style: Get.textTheme.bodyLarge),
      ),
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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
                            ChoiceChip(
                              label: Text('contractor'.tr()),
                              selected:
                                  controller.selectedRole.value == 'contractor',
                              selectedColor: primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    controller.selectedRole.value ==
                                        'contractor'
                                    ? Colors.white
                                    : Get.theme.textTheme.bodyMedium!.color,
                              ),
                              onSelected: (selected) {
                                if (selected)
                                  controller.selectRole('contractor');
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text('project_owner'.tr()),
                              selected:
                                  controller.selectedRole.value ==
                                  'project_owner',
                              selectedColor: primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    controller.selectedRole.value ==
                                        'project_owner'
                                    ? Colors.white
                                    : Get.theme.textTheme.bodyMedium!.color,
                              ),
                              onSelected: (selected) {
                                if (selected)
                                  controller.selectRole('project_owner');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'email'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email),
                          ),
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
                          onChanged: (value) => controller.email.value = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'phone'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_phone'.tr();
                            }
                            return null;
                          },
                          onChanged: (value) => controller.phone.value = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'password'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_password'.tr();
                            }
                            if (value.length < 6) {
                              return 'password_too_short'.tr();
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              controller.password.value = value,
                        ),
                      ] else if (controller.selectedRole.value ==
                          'contractor') ...[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'name'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_name'.tr();
                            }
                            return null;
                          },
                          onChanged: (value) => controller.name.value = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'prename'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_prename'.tr();
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              controller.prename.value = value,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'wilaya'.tr(),
                            border: const OutlineInputBorder(),
                          ),
                          items: wilayas
                              .map(
                                (wilaya) => DropdownMenuItem(
                                  value: wilaya,
                                  child: Text(
                                    wilaya,
                                    style: const TextStyle(
                                      fontFamily: 'NotoKufiArabic',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.wilaya.value = value ?? '',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_select_wilaya'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'activity_sector'.tr(),
                            border: const OutlineInputBorder(),
                          ),
                          items: activitySectors
                              .map(
                                (sector) => DropdownMenuItem(
                                  value: sector,
                                  child: Text(
                                    sector,
                                    style: const TextStyle(
                                      fontFamily: 'NotoKufiArabic',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.activitySector.value = value ?? '',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_select_activity_sector'.tr();
                            }
                            return null;
                          },
                        ),
                      ] else ...[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'company_name'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.business),
                          ),
                          onChanged: (value) =>
                              controller.companyName.value = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'company_address'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                          onChanged: (value) =>
                              controller.companyAddress.value = value,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'company_phone'.tr(),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) =>
                              controller.companyPhone.value = value,
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (controller.currentStep.value == 1) {
                                  controller.nextStep();
                                } else {
                                  if (controller.selectedRole.value ==
                                          'contractor' &&
                                      (controller.name.value.isEmpty ||
                                          controller.prename.value.isEmpty ||
                                          controller.wilaya.value.isEmpty ||
                                          controller
                                              .activitySector
                                              .value
                                              .isEmpty)) {
                                    Get.snackbar(
                                      'خطأ'.tr(),
                                      'please_fill_all_fields'.tr(),
                                    );
                                    return;
                                  }
                                  controller.signUp();
                                }
                              }
                            },
                            child: Text(
                              controller.currentStep.value == 1
                                  ? 'next'.tr()
                                  : 'signup'.tr(),
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
}
