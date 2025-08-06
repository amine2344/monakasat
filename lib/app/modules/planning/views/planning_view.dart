import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import 'package:easy_localization/easy_localization.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/planning_controller.dart';

class PlanningView extends GetView<PlanningController> {
  const PlanningView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController projectNameController = TextEditingController();
    final TextEditingController needsController = TextEditingController();
    final TextEditingController budgetController = TextEditingController();
    var selectedServiceType = ''.obs;

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'planning_needs'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              TextField(
                controller: projectNameController,
                decoration: InputDecoration(labelText: 'project_name'.tr()),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'service_type'.tr()),
                items:
                    [
                          'أشغال البناء والهندسة المدنية'.tr(),
                          'صناعات الصلب والمعادن ومواد البناء'.tr(),
                          'الصناعة الكهربائية'.tr(),
                          'الدراسات و الإستشارات'.tr(),
                        ]
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) => selectedServiceType.value = value ?? '',
              ),
              TextField(
                controller: needsController,
                decoration: InputDecoration(labelText: 'needs'.tr()),
                maxLines: 4,
              ),
              TextField(
                controller: budgetController,
                decoration: InputDecoration(labelText: 'budget'.tr()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.savePlanning(
                          projectNameController.text,
                          selectedServiceType.value,
                          needsController.text,
                          budgetController.text,
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
