import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';

import '../../../../utils/theme_config.dart';
import '../../../data/models/offer_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/open_envloppes_controller.dart';

class OpenEnvelopesView extends GetView<OpenEnvelopesController> {
  const OpenEnvelopesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'open_envelopes'.tr(),
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
                          Text(
                            '${'execution_duration'.tr()}: ${offer.duration}',
                          ),
                        ],
                      ), //TODO: UDDATE THIS IT WAS ROUTES.DOCUMENTS
                      trailing: IconButton(
                        icon: const Icon(Icons.description),
                        onPressed: () => Get.toNamed(
                          Routes.DASHBOARD,
                          arguments: offer.documentUrl,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.generateReport,
        child: Text('generate_report'.tr()),
      ),
    );
  }
}
