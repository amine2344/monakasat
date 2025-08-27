import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:mounakassat_dz/app/controllers/theme_controller.dart';
import 'package:mounakassat_dz/app/widgets/custom_textfield.dart';
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
          style: TextStyle(
            fontFamily: 'NotoKufiArabic',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Directionality(
            textDirection: Get.find<ThemeController>().textDirection.value,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Card(
                elevation: 2,
                color: Get.theme.scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                                ? 'edit_project_details_step2'.tr()
                                : 'enter_project_details_step2'.tr(),
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          CustomTextField(
                            controller: controller.legalRequirementsController,
                            labelText: 'legal_requirements'.tr(),
                            prefixIcon: Icons.gavel,
                            maxLines: 4,
                            validator: (value) => null, // Optional field
                          ),
                          SizedBox(height: 2.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                text: 'upload_documents'.tr(),
                                trailingIcon: Icons.upload_file,
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                fixedSize: Size(90.w, 6.h),
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
                              SizedBox(height: 1.h),
                              Obx(
                                () => controller.selectedFile.value != null
                                    ? _buildFilePreview(
                                        context,
                                        controller.selectedFile.value!,
                                        isImage: false,
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                text: 'upload_featured_image'.tr(),
                                trailingIcon: Icons.image,
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                fixedSize: Size(90.w, 6.h),
                                onPressed: () async {
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                          'jpeg',
                                          'png',
                                        ],
                                      );
                                  if (result != null) {
                                    controller.selectedImage.value = result;
                                  }
                                },
                              ),
                              SizedBox(height: 1.h),
                              Obx(
                                () => controller.selectedImage.value != null
                                    ? _buildFilePreview(
                                        context,
                                        controller.selectedImage.value!,
                                        isImage: true,
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                text: 'start_date'.tr(),
                                trailingIcon: Icons.calendar_today,
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                fixedSize: Size(90.w, 6.h),
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2026),
                                    locale: Locale(context.locale.languageCode),
                                  );
                                  if (pickedDate != null) {
                                    controller.setStartDate(pickedDate);
                                  }
                                },
                              ),
                              SizedBox(height: 1.h),
                              Obx(
                                () => Text(
                                  controller.startDate.value != null
                                      ? DateFormat(
                                          'yyyy-MM-dd',
                                          context.locale.languageCode,
                                        ).format(controller.startDate.value!)
                                      : '',
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomButton(
                                text: 'end_date'.tr(),
                                trailingIcon: Icons.calendar_today,
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                fixedSize: Size(90.w, 6.h),
                                onPressed: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2026),
                                    locale: Locale(context.locale.languageCode),
                                  );
                                  if (pickedDate != null) {
                                    controller.setEndDate(pickedDate);
                                  }
                                },
                              ),
                              SizedBox(height: 1.h),
                              Obx(
                                () => Text(
                                  controller.endDate.value != null
                                      ? DateFormat(
                                          'yyyy-MM-dd',
                                          context.locale.languageCode,
                                        ).format(controller.endDate.value!)
                                      : '',
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          CustomButton(
                            text: isEditing ? 'update'.tr() : 'publish'.tr(),
                            trailingIcon: Icons.send,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: Size(90.w, 8.h),
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
          Obx(
            () => controller.isLoading.value
                ? Stack(
                    children: [
                      ModalBarrier(
                        dismissible: false,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 2.h),
                            Text(
                              'publishing_tender'.tr(),
                              style: TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview(
    BuildContext context,
    FilePickerResult result, {
    required bool isImage,
  }) {
    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;
    final fileSize = (file.lengthSync() / 1024).toStringAsFixed(
      2,
    ); // Size in KB
    final isPdf = fileName.toLowerCase().endsWith('.pdf');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (isImage && !isPdf)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            )
          else
            Icon(Icons.picture_as_pdf, color: primaryColor, size: 15.w),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontFamily: 'NotoKufiArabic',
                    fontSize: 12.sp,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$fileSize KB',
                  style: TextStyle(
                    fontFamily: 'NotoKufiArabic',
                    fontSize: 10.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600], size: 16.sp),
            onPressed: () {
              if (isImage) {
                controller.selectedImage.value = null;
              } else {
                controller.selectedFile.value = null;
              }
            },
          ),
        ],
      ),
    );
  }
}
