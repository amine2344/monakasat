import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:ui' as ui;
import '../../../data/models/tender_model.dart';
import '../../../widgets/tender_item.dart';
import '../../home/controllers/home_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/my_offers_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class MyOffersView extends GetView<MyOffersController> {
  const MyOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();
    final HomeController homeController = Get.find<HomeController>();
    final isProjectOwner = authController.selectedRole.value == 'project_owner';

    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        trailing: isProjectOwner
            ? IconButton(
                icon: Icon(Icons.add, color: lightColor, size: 20.sp),
                onPressed: () => Get.toNamed(Routes.PLANNING),
              )
            : null,
        titleText: isProjectOwner ? 'add_project'.tr() : 'my_offers'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: ui.TextDirection.rtl,
                  children: [
                    // Header
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
                          isProjectOwner
                              ? 'add_project'.tr()
                              : 'my_offers'.tr(),
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
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : controller.myOffers.isEmpty
                    ? Center(
                        child: Text(
                          'no_offers_available'.tr(),
                          style: TextStyle(
                            fontFamily: 'NotoKufiArabic',
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(4.w),
                        itemCount: controller.myOffers.length,
                        itemBuilder: (context, index) {
                          final tender = controller.myOffers[index];
                          final offer = controller.myOfferDetails[index];
                          final isProjectOwner =
                              authController.selectedRole.value ==
                              'project_owner';
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Opacity(opacity: value, child: child);
                            },
                            child: GestureDetector(
                              onTap: () {
                                controller.trackInteraction(
                                  tender.id,
                                  'view_tender_details',
                                );
                                Get.toNamed(
                                  isProjectOwner
                                      ? Routes.TENDER_DETAILS_OWNER
                                      : Routes.TENDER_DETAILS_CONTRACTOR,
                                  arguments: tender,
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: ui.TextDirection.rtl,
                                children: [
                                  TenderItemWidget(
                                    tender: tender,
                                    isProjectOwner: isProjectOwner,
                                    controller: homeController,
                                  ),
                                  SizedBox(height: 1.h),
                                  // Timeline for tender stages
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    child: _buildTimeline(tender, offer),
                                  ),
                                  SizedBox(height: 2.h),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(TenderModel tender, Map<String, dynamic> offer) {
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
                if (index == currentStageIndex &&
                    !(Get.find<AuthController>().selectedRole.value ==
                        'project_owner')) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    '${'offer_status'.tr()}: ${offer['status'].toString().tr()}',
                    style: TextStyle(
                      fontFamily: 'NotoKufiArabic',
                      fontSize: 12.sp,
                      color: offer['status'] == 'accepted'
                          ? Colors.green
                          : offer['status'] == 'rejected'
                          ? Colors.red
                          : Colors.grey[700],
                    ),
                  ),
                ],
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
}
