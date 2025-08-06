import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/final_delivery_controller.dart';

class FinalDeliveryView extends GetView<FinalDeliveryController> {
  const FinalDeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController evaluationController = TextEditingController();
    var selectedFile = Rxn<FilePickerResult>();
    var rating = 0.0.obs;

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'final_delivery'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              TextField(
                controller: evaluationController,
                decoration: InputDecoration(labelText: 'final_evaluation'.tr()),
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
              Slider(
                value: rating.value,
                onChanged: (value) => rating.value = value,
                min: 0.0,
                max: 5.0,
                divisions: 5,
                label: rating.value.toString(),
              ),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.completeDelivery(
                          evaluationController.text,
                          rating.value,
                          selectedFile.value,
                        );
                      },
                      child: Text('complete'.tr()),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
