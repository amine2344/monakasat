import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/execution_controller.dart';

class ExecutionView extends GetView<ExecutionController> {
  const ExecutionView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController reportController = TextEditingController();
    var selectedFile = Rxn<FilePickerResult>();
    var progress = 0.0.obs;

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'execution_followup'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              Text('progress_percentage'.tr()),
              LinearPercentIndicator(
                percent: progress.value,
                lineHeight: 20,
                progressColor: primaryColor,
              ),
              TextField(
                controller: reportController,
                decoration: InputDecoration(labelText: 'progress_report'.tr()),
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
              const SizedBox(height: 20),
              Slider(
                value: progress.value,
                onChanged: (value) => progress.value = value,
                min: 0.0,
                max: 1.0,
              ),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.updateProgress(
                          progress.value,
                          reportController.text,
                          selectedFile.value,
                        );
                      },
                      child: Text('save'.tr()),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
