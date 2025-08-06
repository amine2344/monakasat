import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/submit_offers_controller.dart';

class SubmitOffersView extends GetView<SubmitOffersController> {
  const SubmitOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController financialOfferController =
        TextEditingController();
    final TextEditingController technicalOfferController =
        TextEditingController();
    final TextEditingController durationController = TextEditingController();
    var selectedFile = Rxn<FilePickerResult>();

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'submit_offers'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              TextField(
                controller: financialOfferController,
                decoration: InputDecoration(labelText: 'financial_offer'.tr()),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: technicalOfferController,
                decoration: InputDecoration(labelText: 'technical_offer'.tr()),
                maxLines: 4,
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: 'execution_duration'.tr(),
                ),
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
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.submitOffer(
                          financialOfferController.text,
                          technicalOfferController.text,
                          durationController.text,
                          selectedFile.value,
                        );
                      },
                      child: Text('submit_offers'.tr()),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
