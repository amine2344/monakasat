import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';

import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth/views/signup_view.dart';
import '../controllers/planning_controller.dart';

class PlanningView extends GetView<PlanningController> {
  const PlanningView({super.key});

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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final projectNameController = TextEditingController();
    final serviceTypeController = TextEditingController();
    final requirementsController = TextEditingController();
    final budgetController = TextEditingController();
    final projectId = Get.arguments?['projectId'] as String?;
    final isEditing = projectId != null;

    // If editing, populate fields with existing data
    if (isEditing) {
      ever(controller.isLoading, (_) {
        if (!controller.isLoading.value) {
          controller.firebaseService.firestore
              .collection('projects')
              .doc(projectId)
              .get()
              .then((doc) {
                if (doc.exists) {
                  final data = doc.data()!;
                  projectNameController.text = data['projectName'] ?? '';
                  serviceTypeController.text = data['serviceType'] ?? '';
                  requirementsController.text = data['requirements'] ?? '';
                  budgetController.text = data['budget']?.toString() ?? '';
                }
              });
        }
      });
    }

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          isEditing ? 'edit_project'.tr() : 'project_planning'.tr(),
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
                            ? (isEditing
                                  ? 'edit_project_details'.tr()
                                  : 'enter_project_details'.tr())
                            : 'announce_tender'.tr(),
                        style: const TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (controller.currentStep.value == 1) ...[
                        CustomTextField(
                          controller: projectNameController,
                          labelText: 'project_name'.tr(),
                          prefixIcon: Icons.description,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'please_enter_project_name'.tr();
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: serviceTypeController,
                          labelText: 'service_type'.tr(),
                          prefixIcon: Icons.category,
                          isDropdown: true,
                          onTap: () => _showSelectionDialog(
                            context,
                            SignUpView.activitySectors,
                            'service_type',
                            (value) => serviceTypeController.text = value,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'please_select_service_type'.tr();
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: requirementsController,
                          labelText: 'requirements'.tr(),
                          prefixIcon: Icons.list,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'please_enter_requirements'.tr();
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: budgetController,
                          labelText: 'budget'.tr(),
                          prefixIcon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'please_enter_budget'.tr();
                            if (double.tryParse(value) == null ||
                                double.parse(value) <= 0) {
                              return 'invalid_budget'.tr();
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: controller.currentStep.value == 1
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if (controller.currentStep.value == 2)
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
                                : 'publish'.tr(),
                            trailingIcon: controller.currentStep.value == 1
                                ? Icons.arrow_forward
                                : Icons.send,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: controller.currentStep.value == 1
                                ? Size(70.w, 8.h)
                                : Size(50.w, 8.h),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            borderRadius: 8,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (controller.currentStep.value == 1) {
                                  if (isEditing) {
                                    controller.updateProjectDetails(
                                      projectId: projectId!,
                                      projectName: projectNameController.text,
                                      serviceType: serviceTypeController.text,
                                      requirements: requirementsController.text,
                                      budget: double.parse(
                                        budgetController.text,
                                      ),
                                    );
                                  } else {
                                    controller.saveProjectDetails(
                                      projectName: projectNameController.text,
                                      serviceType: serviceTypeController.text,
                                      requirements: requirementsController.text,
                                      budget: double.parse(
                                        budgetController.text,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ],
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
