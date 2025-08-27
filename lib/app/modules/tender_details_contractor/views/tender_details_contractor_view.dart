import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:ui' as ui;
import '../../../widgets/custom_textfield.dart';
import '../../../controllers/theme_controller.dart';
import '../../../data/models/tender_model.dart';
import '../controllers/tender_details_contractor_controller.dart';

class TenderDetailsWidget extends StatelessWidget {
  final TenderModel tender;
  final TenderDetailsContractorController controller;
  final GlobalKey<FormState> formKey;
  final TextEditingController offerAmountController;
  final TextEditingController offerDetailsController;
  final TextEditingController executionDurationController;

  const TenderDetailsWidget({
    super.key,
    required this.tender,
    required this.controller,
    required this.formKey,
    required this.offerAmountController,
    required this.offerDetailsController,
    required this.executionDurationController,
  });

  Future<void> _launchDocument(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'error'.tr(),
        'cannot_open_document'.tr(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: ui.TextDirection.rtl,
          children: [
            tender.featuredImageUrl != null
                ? Image.network(
                    tender.featuredImageUrl!,
                    width: 100.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/defaultBeeYellow.png',
                      width: 100.w,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/defaultBeeYellow.png',
                    width: 100.w,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: ui.TextDirection.rtl,
                    children: [
                      SvgPicture.string(
                        '''
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                          <polyline points="14 2 14 8 20 8"></polyline>
                          <line x1="16" y1="13" x2="8" y2="13"></line>
                          <line x1="16" y1="17" x2="8" y2="17"></line>
                          <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                        ''',
                        width: 24,
                        height: 24,
                        color: primaryColor,
                      ),
                      Text(
                        'tender_details'.tr(),
                        style: TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Divider(color: Colors.grey[300]),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: ui.TextDirection.rtl,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.title, color: primaryColor, size: 18.sp),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                tender.projectName.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  tender.category ?? 'N/A',
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[700],
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    tender.wilaya ?? 'N/A',
                                    style: TextStyle(
                                      fontFamily: 'NotoKufiArabic',
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'ar',
                                      symbol: 'DZD ',
                                    ).format(tender.budget),
                                    style: TextStyle(
                                      fontFamily: 'NotoKufiArabic',
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.build,
                                    color: primaryColor,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    tender.serviceType,
                                    style: TextStyle(
                                      fontFamily: 'NotoKufiArabic',
                                      fontSize: 14.sp,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (tender.documentName != null) ...[
                          SizedBox(height: 1.h),
                          GestureDetector(
                            onTap: () => _launchDocument(tender.documentUrl),
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: Radius.circular(10),
                                color: Colors.grey[700]!,
                                strokeWidth: 1,
                              ),

                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 1.h,
                                  horizontal: 3.w,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: ui.TextDirection.rtl,
                                  children: [
                                    Text(
                                      'download_requirements'.tr(),
                                      style: TextStyle(
                                        fontFamily: 'NotoKufiArabic',
                                        fontSize: 14.sp,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Icon(
                                      Icons.cloud_download,
                                      color: Colors.grey[700],
                                      size: 30.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Obx(
                    () => controller.userOffer.value != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: ui.TextDirection.rtl,
                            children: [
                              Text(
                                'your_offer'.tr(),
                                style: TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Card(
                                  color: Get.theme.scaffoldBackgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(2.w),
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: primaryColor,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 2.w),
                                        Expanded(
                                          child: Text(
                                            controller
                                                    .userOffer
                                                    .value!['contractorName'] ??
                                                'Unknown',
                                            style: TextStyle(
                                              fontFamily: 'NotoKufiArabic',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      textDirection: ui.TextDirection.rtl,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              NumberFormat.currency(
                                                locale: 'ar',
                                                symbol: 'DZD ',
                                              ).format(
                                                controller
                                                    .userOffer
                                                    .value!['offerAmount'],
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'NotoKufiArabic',
                                                fontSize: 14.sp,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.description,
                                              color: Colors.grey[700],
                                              size: 14.sp,
                                            ),
                                            SizedBox(width: 2.w),
                                            Expanded(
                                              child: Text(
                                                controller
                                                        .userOffer
                                                        .value!['offerDetails'] ??
                                                    'N/A',
                                                style: TextStyle(
                                                  fontFamily: 'NotoKufiArabic',
                                                  fontSize: 14.sp,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (controller
                                                .userOffer
                                                .value!['executionDuration'] !=
                                            null) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.timer,
                                                color: Colors.grey[700],
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 2.w),
                                              Text(
                                                '${controller.userOffer.value!['executionDuration']} ${'days'.tr()}',
                                                style: TextStyle(
                                                  fontFamily: 'NotoKufiArabic',
                                                  fontSize: 13.sp,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        if (controller
                                                .userOffer
                                                .value!['documentName'] !=
                                            null) ...[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.file_present,
                                                color: Colors.blue,
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 2.w),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => _launchDocument(
                                                    controller
                                                        .userOffer
                                                        .value!['documentUrl'],
                                                  ),
                                                  child: Text(
                                                    controller
                                                        .userOffer
                                                        .value!['documentName'],
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'NotoKufiArabic',
                                                      fontSize: 13.sp,
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info,
                                              color: Colors.grey[600],
                                              size: 14.sp,
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                              controller
                                                  .userOffer
                                                  .value!['status']
                                                  .toString()
                                                  .tr(),
                                              style: TextStyle(
                                                fontFamily: 'NotoKufiArabic',
                                                fontSize: 13.sp,
                                                color:
                                                    controller
                                                            .userOffer
                                                            .value!['status'] ==
                                                        'accepted'
                                                    ? Colors.green
                                                    : controller
                                                              .userOffer
                                                              .value!['status'] ==
                                                          'rejected'
                                                    ? Colors.red
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : controller.tender.stage == 'announced' &&
                              controller.tender.endDate.isAfter(DateTime.now())
                        ? Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textDirection: ui.TextDirection.rtl,
                              children: [
                                Text(
                                  'submit_offer'.tr(),
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                CustomTextField(
                                  controller: offerAmountController,
                                  labelText: 'offer_amount'.tr(),
                                  keyboardType: TextInputType.number,
                                  textStyle: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_offer_amount'.tr();
                                    }
                                    if (double.tryParse(value) == null ||
                                        double.parse(value) <= 0) {
                                      return 'invalid_offer_amount'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                CustomTextField(
                                  controller: offerDetailsController,
                                  labelText: 'offer_details'.tr(),
                                  maxLines: 4,
                                  textStyle: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'please_enter_offer_details'.tr();
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                CustomTextField(
                                  controller: executionDurationController,
                                  labelText:
                                      '${'execution_duration'.tr()} (يوم)',
                                  keyboardType: TextInputType.number,
                                  textStyle: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (int.tryParse(value) == null ||
                                          int.parse(value) <= 0) {
                                        return 'invalid_execution_duration'
                                            .tr();
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 1.h),
                                Obx(
                                  () => GestureDetector(
                                    onTap: controller.isLoading.value
                                        ? null
                                        : controller.pickDocument,
                                    child: DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: Radius.circular(10),
                                        color: Colors.grey[700]!,
                                        strokeWidth: 1,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2.h,
                                          horizontal: 3.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          textDirection: ui.TextDirection.rtl,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                controller.selectedFile.value ==
                                                        null
                                                    ? 'upload_document'.tr()
                                                    : controller
                                                          .selectedFile
                                                          .value!
                                                          .files
                                                          .single
                                                          .name,
                                                style: TextStyle(
                                                  fontFamily: 'NotoKufiArabic',
                                                  fontSize: 14.sp,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            controller.selectedFile.value ==
                                                    null
                                                ? Image.asset(
                                                    'assets/images/upload-file.png',
                                                    width: 50.sp,
                                                    height: 50.sp,
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.clear,
                                                      color: Colors.red,
                                                      size: 16.sp,
                                                    ),
                                                    onPressed:
                                                        controller
                                                            .isLoading
                                                            .value
                                                        ? null
                                                        : () =>
                                                              controller
                                                                      .selectedFile
                                                                      .value =
                                                                  null,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                CustomButton(
                                  text: 'submit_offer'.tr(),
                                  trailingIcon: Icons.send,
                                  backgroundColor: controller.isLoading.value
                                      ? Colors.grey
                                      : primaryColor,
                                  textColor: Colors.white,
                                  iconColor: Colors.white,
                                  fixedSize: Size(100.w, 8.h),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                    horizontal: 4.w,
                                  ),
                                  borderRadius: 8,
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            controller.submitOffer(
                                              offerAmountController.text,
                                              offerDetailsController.text,
                                              executionDurationController.text,
                                            );
                                            offerAmountController.clear();
                                            offerDetailsController.clear();
                                            executionDurationController.clear();
                                          }
                                        },
                                ),
                              ],
                            ),
                          )
                        : Text(
                            'offer_submission_closed'.tr(),
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                  ),
                  if (controller.isLoading.value) ...[
                    SizedBox(height: 2.h),
                    Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => controller.isLoading.value
              ? Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 2.h),
                          Text(
                            'submitting_offer'.tr(),
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}

class TenderDetailsContractorView
    extends GetView<TenderDetailsContractorController> {
  const TenderDetailsContractorView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final offerAmountController = TextEditingController();
    final offerDetailsController = TextEditingController();
    final executionDurationController = TextEditingController();

    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'tender_details'.tr(),
        backgroundColor: primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Directionality(
              textDirection: Get.find<ThemeController>().textDirection.value,
              child: TenderDetailsWidget(
                tender: controller.tender,
                controller: controller,
                formKey: formKey,
                offerAmountController: offerAmountController,
                offerDetailsController: offerDetailsController,
                executionDurationController: executionDurationController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
