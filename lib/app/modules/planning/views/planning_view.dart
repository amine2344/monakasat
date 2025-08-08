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
    final projectId = Get.arguments?['projectId'] as String?;
    final isEditing = projectId != null;

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
                        isEditing
                            ? 'edit_project_details'.tr()
                            : 'enter_project_details'.tr(),
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
                          SignUpView.activitySectors,
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
                          [
                            'Construction',
                            'IT',
                            'Consulting',
                          ], // Replace with your categories
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
                          [
                            'Algiers',
                            'Oran',
                            'Constantine',
                          ], // Replace with your wilayas
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
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: controller.legalRequirementsController,
                        labelText: 'legal_requirements'.tr(),
                        prefixIcon: Icons.gavel,
                        maxLines: 4,
                        validator: (value) {
                          return null; // Optional field
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomButton(
                            text: 'upload_documents'.tr(),
                            trailingIcon: Icons.upload_file,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: Size(50.w, 6.h),
                            onPressed: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'jpg',
                                      'jpeg',
                                      'png',
                                      'pdf',
                                    ],
                                  );
                              if (result != null) {
                                controller.selectedFile.value = result;
                              }
                            },
                          ),
                          SizedBox(width: 2.w),
                          Obx(
                            () => controller.selectedFile.value != null
                                ? Flexible(
                                    child: Text(
                                      controller
                                          .selectedFile
                                          .value!
                                          .files
                                          .single
                                          .name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'NotoKufiArabic',
                                      ),
                                    ),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomButton(
                            text: 'start_date'.tr(),
                            trailingIcon: Icons.calendar_today,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: Size(50.w, 6.h),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2026),
                              );
                              if (pickedDate != null) {
                                controller.setStartDate(pickedDate);
                              }
                            },
                          ),
                          SizedBox(width: 2.w),
                          Obx(
                            () => Text(
                              controller.startDate.value != null
                                  ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(controller.startDate.value!)
                                  : '',
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CustomButton(
                            text: 'end_date'.tr(),
                            trailingIcon: Icons.calendar_today,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: Size(50.w, 6.h),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2026),
                              );
                              if (pickedDate != null) {
                                controller.setEndDate(pickedDate);
                              }
                            },
                          ),
                          SizedBox(width: 2.w),
                          Obx(
                            () => Text(
                              controller.endDate.value != null
                                  ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(controller.endDate.value!)
                                  : '',
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: isEditing ? 'update'.tr() : 'publish'.tr(),
                        trailingIcon: Icons.send,
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
                                  controller.announceTender(
                                    projectId: projectId,
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
