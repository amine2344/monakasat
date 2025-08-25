import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth/views/signup_view.dart';
import '../controllers/planning_controller.dart';
import 'planning.step2.view.dart';

class PlanningStep1View extends GetView<PlanningController> {
  const PlanningStep1View({super.key});

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
    final projectId = Get.arguments?['projectId'] as String?;
    final isEditing = projectId != null;

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          isEditing ? 'edit_project_step1'.tr() : 'project_planning_step1'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            color: Colors.white,
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
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 5.w),
              child: Obx(
                () => Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEditing
                            ? 'edit_project_details_step1'.tr()
                            : 'enter_project_details_step1'.tr(),
                        style: const TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.projectNameController,
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
                        controller: controller.serviceTypeController,
                        labelText: 'service_type'.tr(),
                        prefixIcon: Icons.category,
                        isDropdown: true,
                        onTap: () => _showSelectionDialog(
                          context,
                          SignUpView.tenderType,
                          'service_type',
                          (value) =>
                              controller.serviceTypeController.text = value,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'please_select_service_type'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.categoryController,
                        labelText: 'category'.tr(),
                        prefixIcon: Icons.label,
                        isDropdown: true,
                        onTap: () => _showSelectionDialog(
                          context,
                          SignUpView.activitySectors,
                          'category',
                          (value) => controller.categoryController.text = value,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'please_select_category'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.wilayaController,
                        labelText: 'wilaya'.tr(),
                        prefixIcon: Icons.location_on,
                        isDropdown: true,
                        onTap: () => _showSelectionDialog(
                          context,
                          SignUpView.wilayas,
                          'wilaya',
                          (value) => controller.wilayaController.text = value,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'please_select_wilaya'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.requirementsController,
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
                        controller: controller.budgetController,
                        labelText: "${'budget'.tr()} دج",
                        prefixIcon: Icons.import_contacts_sharp,
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
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'save_and_continue'.tr(),
                        trailingIcon: Icons.arrow_forward,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        fixedSize: Size(70.w, 8.h),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        borderRadius: 8,
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  Get.to(
                                    () => const PlanningStep2View(),
                                    arguments: Get.arguments,
                                  );
                                }
                              },
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
