import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/announce_controller.dart';

class AnnounceView extends GetView<AnnounceController> {
  const AnnounceView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController legalRequirementsController =
        TextEditingController();
    var selectedFile = Rxn<FilePickerResult>();

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'announce_tender'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              TextField(
                controller: legalRequirementsController,
                decoration: InputDecoration(
                  labelText: 'legal_requirements'.tr(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    selectedFile.value = result;
                  }
                },
                child: Text('upload_documents'.tr()),
              ),
              if (selectedFile.value != null)
                Text(selectedFile.value!.files.single.name),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
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
                      child: Text('start_date'.tr()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
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
                      child: Text('end_date'.tr()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.announceTender(
                          legalRequirementsController.text,
                          selectedFile.value,
                        );
                      },
                      child: Text('publish'.tr()),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
