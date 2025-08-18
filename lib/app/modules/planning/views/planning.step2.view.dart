import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../controllers/planning_controller.dart';

class PlanningStep2View extends GetView<PlanningController> {
  const PlanningStep2View({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final projectId = Get.arguments?['projectId'] as String?;
    final isEditing = projectId != null;

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          isEditing ? 'edit_project_step2'.tr() : 'tender_announce_step2'.tr(),
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
                            ? 'edit_project_details_step2'.tr()
                            : 'enter_project_details_step2'.tr(),
                        style: const TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
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
                            text: 'upload_featured_image'.tr(),
                            trailingIcon: Icons.image,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: Size(50.w, 6.h),
                            onPressed: () async {
                              final result = await FilePicker.platform
                                  .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                                  );
                              if (result != null) {
                                controller.selectedImage.value = result;
                              }
                            },
                          ),
                          SizedBox(width: 2.w),
                          Obx(
                            () => controller.selectedImage.value != null
                                ? Flexible(
                                    child: Text(
                                      controller
                                          .selectedImage
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
                                  if (controller.startDate.value == null ||
                                      controller.endDate.value == null) {
                                    Get.snackbar(
                                      'error'.tr(),
                                      'please_select_dates'.tr(),
                                    );
                                    return;
                                  }
                                  if (controller.endDate.value!.isBefore(
                                    controller.startDate.value!,
                                  )) {
                                    Get.snackbar(
                                      'error'.tr(),
                                      'end_date_before_start'.tr(),
                                    );
                                    return;
                                  }
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
