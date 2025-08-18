import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../utils/theme_config.dart';
import '../controllers/announce_controller.dart';

class AnnounceView extends GetView<AnnounceController> {
  const AnnounceView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController projectNameController = TextEditingController();
    final TextEditingController serviceTypeController = TextEditingController();
    final TextEditingController requirementsController =
        TextEditingController();
    final TextEditingController budgetController = TextEditingController();
    final TextEditingController legalRequirementsController =
        TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController wilayaController = TextEditingController();
    var selectedFile = Rxn<FilePickerResult>();

    return Scaffold(
      appBar: AppBar(
        title: Text('announce_tender'.tr()),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: projectNameController,
                decoration: InputDecoration(labelText: 'project_name'.tr()),
              ),
              TextField(
                controller: serviceTypeController,
                decoration: InputDecoration(labelText: 'service_type'.tr()),
              ),
              TextField(
                controller: requirementsController,
                decoration: InputDecoration(labelText: 'requirements'.tr()),
                maxLines: 3,
              ),
              TextField(
                controller: budgetController,
                decoration: InputDecoration(labelText: 'budget'.tr()),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: legalRequirementsController,
                decoration: InputDecoration(
                  labelText: 'legal_requirements'.tr(),
                ),
                maxLines: 3,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'category'.tr()),
              ),
              TextField(
                controller: wilayaController,
                decoration: InputDecoration(labelText: 'wilaya'.tr()),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                        );
                        if (result != null) {
                          selectedFile.value = result;
                        }
                      },
                      child: Text('upload_documents'.tr()),
                    ),
                    if (selectedFile.value != null)
                      Text(selectedFile.value!.files.single.name),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
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
                    child: Text('start_date'.tr()),
                  ),
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
              Row(
                children: [
                  TextButton(
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
                    child: Text('end_date'.tr()),
                  ),
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
              const SizedBox(height: 16),
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (projectNameController.text.isEmpty ||
                              serviceTypeController.text.isEmpty ||
                              requirementsController.text.isEmpty ||
                              budgetController.text.isEmpty ||
                              categoryController.text.isEmpty ||
                              wilayaController.text.isEmpty) {
                            Get.snackbar(
                              'error'.tr(),
                              'please_fill_all_fields'.tr(),
                            );
                            return;
                          }
                          final budget = double.tryParse(budgetController.text);
                          if (budget == null) {
                            Get.snackbar('error'.tr(), 'invalid_budget'.tr());
                            return;
                          }
                          controller.announceTender(
                            legalRequirementsController.text,
                            selectedFile.value,
                            projectName: projectNameController.text,
                            serviceType: serviceTypeController.text,
                            requirements: requirementsController.text,
                            budget: budget,
                            category: categoryController.text,
                            wilaya: wilayaController.text,
                          );
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text('publish'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
