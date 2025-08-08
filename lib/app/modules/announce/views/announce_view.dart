import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_textfield.dart';
import '../../planning/controllers/planning_controller.dart';
import '../controllers/announce_controller.dart';

class AnnounceView extends GetView<AnnounceController> {
  const AnnounceView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final legalRequirementsController = TextEditingController();
    var selectedFile = Rxn<FilePickerResult>();
    final planningController = Get.find<PlanningController>();
    final projectId = Get.arguments?['projectId'] as String?;

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(
          'announce_tender'.tr(),
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
                        'announce_tender'.tr(),
                        style: const TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: legalRequirementsController,
                        labelText: 'legal_requirements'.tr(),
                        prefixIcon: Icons.gavel,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'please_enter_legal_requirements'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'upload_documents'.tr(),
                        trailingIcon: Icons.upload_file,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        fixedSize: Size(70.w, 8.h),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        borderRadius: 8,
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null) {
                            selectedFile.value = result;
                          }
                        },
                      ),
                      if (selectedFile.value != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          selectedFile.value!.files.single.name,
                          style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'start_date'.tr(),
                              trailingIcon: Icons.calendar_today,
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              fixedSize: Size(35.w, 8.h),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              borderRadius: 8,
                              onPressed: () async {
                                final startDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (startDate != null) {
                                  controller.setStartDate(startDate);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'end_date'.tr(),
                              trailingIcon: Icons.calendar_today,
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              fixedSize: Size(35.w, 8.h),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              borderRadius: 8,
                              onPressed: () async {
                                final endDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (endDate != null) {
                                  controller.setEndDate(endDate);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: planningController.previousStep,
                            child: Text(
                              'previous'.tr(),
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                color: primaryColor,
                              ),
                            ),
                          ),
                          CustomButton(
                            text: 'publish'.tr(),
                            trailingIcon: Icons.send,
                            backgroundColor: primaryColor,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            fixedSize: Size(50.w, 8.h),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            borderRadius: 8,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.announceTender(
                                  legalRequirementsController.text,
                                  selectedFile.value,
                                  projectId: projectId,
                                  projectName:
                                      Get.arguments?['projectName'] ??
                                      planningController.projectName.value,
                                  serviceType:
                                      Get.arguments?['serviceType'] ??
                                      planningController.serviceType.value,
                                  requirements:
                                      Get.arguments?['requirements'] ??
                                      planningController.requirements.value,
                                  budget:
                                      Get.arguments?['budget'] ??
                                      planningController.budget.value,
                                );
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
