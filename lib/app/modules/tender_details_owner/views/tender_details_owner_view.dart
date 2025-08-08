import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/tender_details_owner_controller.dart';

class TenderDetailsOwnerView extends GetView<TenderDetailsOwnerController> {
  const TenderDetailsOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'tender_details'.tr()),
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Get.theme.scaffoldBackgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.tender.projectName,
                      style: const TextStyle(
                        fontFamily: 'NotoKufiArabic',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'category'.tr(args: [controller.tender.serviceType]),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'wilaya'.tr(args: [controller.tender.wilaya ?? 'N/A']),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'budget'.tr(args: [controller.tender.budget.toString()]),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'requirements'.tr(args: [controller.tender.requirements]),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'legal_requirements'.tr(
                        args: [controller.tender.legalRequirements],
                      ),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'start_date'.tr(
                        args: [
                          controller.tender.startDate.toString().substring(
                            0,
                            10,
                          ),
                        ],
                      ),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'end_date'.tr(
                        args: [
                          controller.tender.endDate.toString().substring(0, 10),
                        ],
                      ),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    Text(
                      'stage'.tr(args: [controller.tender.stage]),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                    if (controller.tender.documentName != null) ...[
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'download_document'.tr(),
                        trailingIcon: Icons.download,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        fixedSize: Size(70.w, 8.h),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        borderRadius: 8,
                        onPressed: () {
                          Get.snackbar(
                            'info'.tr(),
                            'download_not_implemented'.tr(),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      'offers_received'.tr(),
                      style: const TextStyle(
                        fontFamily: 'NotoKufiArabic',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    controller.offers.isEmpty
                        ? Text(
                            'no_offers_available'.tr(),
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.offers.length,
                            itemBuilder: (context, index) {
                              final offer = controller.offers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ListTile(
                                  title: Text(
                                    offer['contractorName'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontFamily: 'NotoKufiArabic',
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'offer_amount'.tr(
                                          args: [
                                            offer['offerAmount'].toString(),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'offer_details'.tr(
                                          args: [
                                            offer['offerDetails'] ?? 'N/A',
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'status'.tr(
                                          args: [offer['status'] ?? 'pending'],
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: offer['status'] == 'pending'
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              onPressed: () =>
                                                  controller.updateOfferStatus(
                                                    offer['id'],
                                                    'accepted',
                                                  ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  controller.updateOfferStatus(
                                                    offer['id'],
                                                    'rejected',
                                                  ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 24),
                    if (controller.tender.stage == 'announced')
                      CustomButton(
                        text: 'mark_under_review'.tr(),
                        trailingIcon: Icons.hourglass_empty,
                        backgroundColor: primaryColor,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        fixedSize: Size(70.w, 8.h),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        borderRadius: 8,
                        onPressed: () =>
                            controller.updateTenderStage('under_review'),
                      ),
                    if (controller.isLoading.value)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
