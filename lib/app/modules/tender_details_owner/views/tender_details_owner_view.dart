import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:mounakassat_dz/app/modules/auth/controllers/auth_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:ui' as ui;
import '../../../controllers/theme_controller.dart';
import '../../../data/models/tender_model.dart';
import '../controllers/tender_details_owner_controller.dart';

class TenderDetailsWidget extends StatelessWidget {
  final bool isProjectOwnerAccount;
  final TenderDetailsOwnerController controller;

  const TenderDetailsWidget({
    super.key,
    required this.isProjectOwnerAccount,
    required this.controller,
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

  Widget _buildTimeline(TenderModel tender) {
    final stages = [
      {
        'stage': 'announced',
        'title': 'announced'.tr(),
        'description': 'offer_submission_description'.tr(),
      },
      {
        'stage': 'envelope_opened',
        'title': 'envelope_opened'.tr(),
        'description': 'envelope_opening_description'.tr(),
      },
      {
        'stage': 'evaluated',
        'title': 'evaluated'.tr(),
        'description': 'evaluation_description'.tr(),
      },
      {
        'stage': 'contract_signed',
        'title': 'contract_signed'.tr(),
        'description': 'contract_signing_description'.tr(),
      },
      {
        'stage': 'execution',
        'title': 'execution'.tr(),
        'description': 'execution_description'.tr(),
      },
      {
        'stage': 'completed',
        'title': 'completed'.tr(),
        'description': 'completion_description'.tr(),
      },
    ];
    final currentStageIndex = stages.indexWhere(
      (s) => s['stage'] == tender.stage,
    );

    return Column(
      children: List.generate(stages.length, (index) {
        final isCompleted = index <= currentStageIndex;
        final isCurrent = index == currentStageIndex;
        return TimelineTile(
          alignment: TimelineAlign.start,
          isFirst: index == 0,
          isLast: index == stages.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: isCompleted ? primaryColor : Colors.grey,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            iconStyle: isCompleted
                ? IconStyle(
                    iconData: Icons.check,
                    color: Colors.white,
                    fontSize: 12.sp,
                  )
                : null,
          ),
          endChild: Container(
            constraints: BoxConstraints(minHeight: 10.h),
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: ui.TextDirection.rtl,
              children: [
                Text(
                  stages[index]['title']!,
                  style: TextStyle(
                    fontFamily: 'NotoKufiArabic',
                    fontSize: 14.sp,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    color: isCurrent ? primaryColor : Colors.grey[700],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  stages[index]['description']!,
                  style: TextStyle(
                    fontFamily: 'NotoKufiArabic',
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          beforeLineStyle: LineStyle(
            color: isCompleted ? primaryColor : Colors.grey,
            thickness: 2,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value || controller.tender.value == null) {
        return Center(child: CircularProgressIndicator(color: primaryColor));
      }
      final tender = controller.tender.value!;
      return Column(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: ui.TextDirection.rtl,
              children: [
                Padding(
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
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
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
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
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
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.grey[700],
                                  size: 16.sp,
                                ),
                                SizedBox(width: 2.w),
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
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
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
                        Row(
                          children: [
                            Icon(
                              Icons.file_present,
                              color: Colors.blue,
                              size: 16.sp,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _launchDocument(tender.documentUrl),
                                child: Text(
                                  tender.documentName!,
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                _buildTimeline(tender),
                SizedBox(height: 2.h),
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
                if (isProjectOwnerAccount) ...[
                  Text(
                    'offers_received'.tr(),
                    style: TextStyle(
                      fontFamily: 'NotoKufiArabic',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Obx(
                    () => controller.offers.isEmpty
                        ? Text(
                            'no_offers_available'.tr(),
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.offers.length,
                            itemBuilder: (context, index) {
                              final offer = controller.offers[index];
                              return Card(
                                color: Get.theme.scaffoldBackgroundColor,
                                margin: EdgeInsets.symmetric(vertical: 1.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(2.w),
                                  title: Row(
                                    textDirection: ui.TextDirection.rtl,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: primaryColor,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        child: Text(
                                          offer['contractorName'] ?? 'Unknown',
                                          style: TextStyle(
                                            fontFamily: 'NotoKufiArabic',
                                            fontSize: 14.sp,
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
                                          Icon(
                                            Icons.monetization_on,
                                            color: Colors.grey[700],
                                            size: 14.sp,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'ar',
                                              symbol: 'DZD ',
                                            ).format(offer['offerAmount']),
                                            style: TextStyle(
                                              fontFamily: 'NotoKufiArabic',
                                              fontSize: 13.sp,
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
                                              offer['offerDetails'] ?? 'N/A',
                                              style: TextStyle(
                                                fontFamily: 'NotoKufiArabic',
                                                fontSize: 13.sp,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.grey[600],
                                            size: 14.sp,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            offer['status'].toString().tr(),
                                            style: TextStyle(
                                              fontFamily: 'NotoKufiArabic',
                                              fontSize: 13.sp,
                                              color:
                                                  offer['status'] == 'accepted'
                                                  ? Colors.green
                                                  : offer['status'] ==
                                                        'rejected'
                                                  ? Colors.red
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing:
                                      tender.stage == 'evaluated' &&
                                          offer['status'] == 'pending'
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          textDirection: ui.TextDirection.rtl,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 16.sp,
                                              ),
                                              onPressed: () =>
                                                  controller.updateOfferStatus(
                                                    offer['id'],
                                                    'accepted',
                                                  ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 16.sp,
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
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    children: [
                      if (tender.stage == 'announced')
                        CustomButton(
                          text: 'mark_envelope_opened'.tr(),
                          trailingIcon: Icons.folder_open,
                          backgroundColor: primaryColor,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          fixedSize: Size(100.w, 8.h),
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 4.w,
                          ),
                          borderRadius: 8,
                          onPressed: () =>
                              controller.updateTenderStage('envelope_opened'),
                        ),
                      if (tender.stage == 'envelope_opened')
                        CustomButton(
                          text: 'complete_evaluation'.tr(),
                          trailingIcon: Icons.check_circle,
                          backgroundColor: primaryColor,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          fixedSize: Size(100.w, 8.h),
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 4.w,
                          ),
                          borderRadius: 8,
                          onPressed: () =>
                              controller.updateTenderStage('evaluated'),
                        ),
                      if (tender.stage == 'contract_signed')
                        CustomButton(
                          text: 'start_execution'.tr(),
                          trailingIcon: Icons.play_arrow,
                          backgroundColor: primaryColor,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          fixedSize: Size(100.w, 8.h),
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 4.w,
                          ),
                          borderRadius: 8,
                          onPressed: () =>
                              controller.updateTenderStage('execution'),
                        ),
                      if (tender.stage == 'execution')
                        CustomButton(
                          text: 'complete_project'.tr(),
                          trailingIcon: Icons.done_all,
                          backgroundColor: primaryColor,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          fixedSize: Size(100.w, 8.h),
                          padding: EdgeInsets.symmetric(
                            vertical: 2.h,
                            horizontal: 4.w,
                          ),
                          borderRadius: 8,
                          onPressed: () =>
                              controller.updateTenderStage('completed'),
                        ),
                    ],
                  ),
                ],
                if (controller.isLoading.value) ...[
                  SizedBox(height: 2.h),
                  Center(child: CircularProgressIndicator(color: primaryColor)),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }
}

class TenderDetailsOwnerView extends GetView<TenderDetailsOwnerController> {
  const TenderDetailsOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'tender_details'.tr(),
        backgroundColor: primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Directionality(
                textDirection: Get.find<ThemeController>().textDirection.value,
                child: TenderDetailsWidget(
                  isProjectOwnerAccount:
                      Get.find<AuthController>().currentUser?.role !=
                      'contractor',
                  controller: controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
