import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/approve_contract_controller.dart';

class ApproveContractView extends GetView<ApproveContractController> {
  const ApproveContractView({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedFile = Rxn<FilePickerResult>();

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'approve_contract'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    selectedFile.value = result;
                  }
                },
                child: Text('upload_contract'.tr()),
              ),
              if (selectedFile.value != null)
                Text(selectedFile.value!.files.single.name),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.approveContract(selectedFile.value);
                      },
                      child: Text('approve_contract'.tr()),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
