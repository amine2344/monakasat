import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

import '../../../../utils/theme_config.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/evaluate_offers_controller.dart';

class EvaluateOffersView extends GetView<EvaluateOffersController> {
  const EvaluateOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'evaluate_offers'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.offers.length,
                itemBuilder: (context, index) {
                  final offer = controller.offers[index];
                  final TextEditingController scoreController =
                      TextEditingController();
                  return Card(
                    child: ListTile(
                      title: Text('عرض من: ${offer.contractorId}'.tr()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'financial_offer'.tr()}: ${offer.financialOffer}',
                          ),
                          Text(
                            '${'technical_offer'.tr()}: ${offer.technicalOffer}',
                          ),
                          TextField(
                            controller: scoreController,
                            decoration: InputDecoration(
                              labelText: 'evaluation_criteria'.tr(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          controller.evaluateOffer(
                            offer.id,
                            scoreController.text,
                          );
                        },
                        child: Text('select_winner'.tr()),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
