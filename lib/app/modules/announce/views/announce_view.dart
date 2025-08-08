import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/theme_config.dart';
import '../controllers/announce_controller.dart';

class AnnounceView extends GetView<AnnounceController> {
  const AnnounceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'announce_tender'.tr(),
          style: const TextStyle(fontFamily: 'NotoKufiArabic'),
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.projectNameController,
              decoration: InputDecoration(
                labelText: 'project_name'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller.serviceTypeController,
              decoration: InputDecoration(
                labelText: 'service_type'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller.categoryController,
              decoration: InputDecoration(
                labelText: 'category'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller.wilayaController,
              decoration: InputDecoration(
                labelText: 'wilaya'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller.requirementsController,
              decoration: InputDecoration(
                labelText: 'requirements'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller.budgetController,
              decoration: InputDecoration(
                labelText: 'budget'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: controller.legalRequirementsController,
              decoration: InputDecoration(
                labelText: 'legal_requirements'.tr(),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              maxLines: 3,
            ),
            SizedBox(height: 2.h),
            Obx(
              () => Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                      );
                      if (result != null) {
                        controller.selectedFile.value = result;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    child: Text(
                      'upload_documents'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  if (controller.selectedFile.value != null)
                    Flexible(
                      child: Text(
                        controller.selectedFile.value!.files.single.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  child: Text(
                    'start_date'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 2.w),
                Obx(
                  () => Text(
                    controller.startDate.value != null
                        ? DateFormat(
                            'yyyy-MM-dd',
                          ).format(controller.startDate.value!)
                        : '',
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  child: Text(
                    'end_date'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 2.w),
                Obx(
                  () => Text(
                    controller.endDate.value != null
                        ? DateFormat(
                            'yyyy-MM-dd',
                          ).format(controller.endDate.value!)
                        : '',
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (controller.projectNameController.text.isEmpty ||
                            controller.serviceTypeController.text.isEmpty ||
                            controller.requirementsController.text.isEmpty ||
                            controller.budgetController.text.isEmpty ||
                            controller.categoryController.text.isEmpty ||
                            controller.wilayaController.text.isEmpty) {
                          Get.snackbar(
                            'error'.tr(),
                            'please_fill_all_fields'.tr(),
                          );
                          return;
                        }
                        final budget = double.tryParse(
                          controller.budgetController.text,
                        );
                        if (budget == null) {
                          Get.snackbar('error'.tr(), 'invalid_budget'.tr());
                          return;
                        }
                        controller.announceTender(
                          controller.legalRequirementsController.text,
                          controller.selectedFile.value,
                          projectName: controller.projectNameController.text,
                          serviceType: controller.serviceTypeController.text,
                          requirements: controller.requirementsController.text,
                          budget: budget,
                          category: controller.categoryController.text,
                          wilaya: controller.wilayaController.text,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 2.h,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'NotoKufiArabic',
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'publish'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
