import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_textfield.dart';
import '../controllers/tender_details_contractor_controller.dart';

class TenderDetailsContractorView
    extends GetView<TenderDetailsContractorController> {
  const TenderDetailsContractorView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final offerAmountController = TextEditingController();
    final offerDetailsController = TextEditingController();

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
                    if (controller.userOffer.value != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'your_offer'.tr(),
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                controller.userOffer.value!['contractorName'] ??
                                    'Unknown',
                                style: const TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'offer_amount'.tr(
                                      args: [
                                        controller
                                            .userOffer
                                            .value!['offerAmount']
                                            .toString(),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'offer_details'.tr(
                                      args: [
                                        controller
                                                .userOffer
                                                .value!['offerDetails'] ??
                                            'N/A',
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'status'.tr(
                                      args: [
                                        controller.userOffer.value!['status'] ??
                                            'pending',
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (controller.tender.stage == 'announced' &&
                        controller.tender.endDate.isAfter(DateTime.now()))
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'submit_offer'.tr(),
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: offerAmountController,
                              labelText: 'offer_amount'.tr(),
                              prefixIcon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'please_enter_offer_amount'.tr();
                                if (double.tryParse(value) == null ||
                                    double.parse(value) <= 0) {
                                  return 'invalid_offer_amount'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: offerDetailsController,
                              labelText: 'offer_details'.tr(),
                              prefixIcon: Icons.description,
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'please_enter_offer_details'.tr();
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'submit_offer'.tr(),
                              trailingIcon: Icons.send,
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
                                if (formKey.currentState!.validate()) {
                                  controller.submitOffer(
                                    offerAmountController.text,
                                    offerDetailsController.text,
                                  );
                                  offerAmountController.clear();
                                  offerDetailsController.clear();
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        'offer_submission_closed'.tr(),
                        style: const TextStyle(fontFamily: 'NotoKufiArabic'),
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
