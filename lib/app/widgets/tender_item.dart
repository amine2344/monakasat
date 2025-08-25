import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;
import '../../utils/theme_config.dart';
import '../data/models/tender_model.dart';
import '../modules/home/controllers/home_controller.dart';

class TenderItemWidget extends StatelessWidget {
  final TenderModel tender;
  final bool isProjectOwner;
  final HomeController controller;

  const TenderItemWidget({
    super.key,
    required this.tender,
    required this.isProjectOwner,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isSubscribed =
        FirebaseAuth.instance.currentUser !=
        null; // Placeholder for subscription check
    return GestureDetector(
      onTap: () {
        FirebaseAuth.instance.currentUser != null
            ? Get.toNamed(
                isProjectOwner
                    ? Routes.TENDER_DETAILS_OWNER
                    : Routes.TENDER_DETAILS_CONTRACTOR,
                arguments: tender,
              )
            : Get.toNamed(Routes.AUTH);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Favorite button
            Positioned(
              top: 12,
              left: 12,
              child: Obx(
                () => IconButton(
                  icon: Icon(
                    CupertinoIcons.heart_fill,

                    size: 28,
                    color: controller.favorites.contains(tender.id)
                        ? primaryColor
                        : Colors.grey,
                  ),
                  onPressed: () => controller.toggleFavorite(tender.id),
                  tooltip: 'add_to_favorites'.tr(),
                ),
              ),
            ),
            // Main content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: ui.TextDirection.rtl, // RTL support
              children: [
                // Image
                (tender.featuredImageUrl != null &&
                        tender.featuredImageUrl!.isNotEmpty)
                    ? Container(
                        padding: EdgeInsets.all(3.w),
                        child: Image.network(
                          tender.featuredImageUrl!,
                          width: 80,
                          height: 80,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(3.w),
                        child: Image.asset(
                          'assets/images/defaultBeeYellow.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service type and category
                      FittedBox(
                        child: Row(
                          textDirection: ui.TextDirection.rtl,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                tender.serviceType ?? 'منح مؤقتة',
                                style: TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              tender.category ?? 'استشارة وطنية مفتوحة',
                              style: TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 13.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      // Project name
                      Text(
                        tender.projectName.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                        textDirection: ui.TextDirection.rtl,
                      ),
                      SizedBox(height: 1.h),
                      // Category (secteur)
                      Row(
                        textDirection: ui.TextDirection.rtl,
                        children: [
                          Icon(
                            Icons.category,
                            color: Colors.grey[700],
                            size: 16.sp,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            tender.category ?? 'N/A',
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      // Announcer
                      Row(
                        textDirection: ui.TextDirection.rtl,
                        children: [
                          SvgPicture.string(
                            '''
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                              <path d="m8.5,9.5c0,.551.128,1.073.356,1.537-.49.628-.795,1.407-.836,2.256-.941-.988-1.52-2.324-1.52-3.792,0-3.411,3.122-6.107,6.659-5.381,2.082.428,3.769,2.105,4.213,4.184.134.628.159,1.243.091,1.831-.058.498-.495.866-.997.866h-.045c-.592,0-1.008-.527-.943-1.115.044-.395.021-.81-.08-1.233-.298-1.253-1.32-2.268-2.575-2.557-2.286-.525-4.324,1.207-4.324,3.405Zm-3.89-1.295c.274-1.593,1.053-3.045,2.261-4.178,1.529-1.433,3.531-2.141,5.63-2.011,3.953.256,7.044,3.719,6.998,7.865-.019,1.736-1.473,3.118-3.208,3.118h-2.406c-.244-.829-1.002-1.439-1.91-1.439-1.105,0-2,.895-2,2s.895,2,2,2c.538,0,1.025-.215,1.384-.561h2.932c2.819,0,5.168-2.245,5.208-5.063C21.573,4.715,17.651.345,12.63.021c-2.664-.173-5.191.732-7.126,2.548-1.499,1.405-2.496,3.265-2.855,5.266-.109.608.372,1.166.989,1.166.472,0,.893-.329.972-.795Zm7.39,8.795c-3.695,0-6.892,2.292-7.955,5.702-.165.527.13,1.088.657,1.253.526.159,1.087-.131,1.252-.657.789-2.53,3.274-4.298,6.045-4.298s5.257,1.768,6.045,4.298c.134.428.528.702.955.702.099,0,.198-.015.298-.045.527-.165.821-.726.657-1.253-1.063-3.41-4.26-5.702-7.955-5.702Z"></path>
                            </svg>
                            ''',
                            width: 16.sp,
                            height: 16.sp,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            isSubscribed
                                ? (tender.announcer ?? 'N/A')
                                : 'restricted_info'.tr(),
                            style: TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                              fontWeight: isSubscribed
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      // Wilaya
                      Row(
                        textDirection: ui.TextDirection.rtl,
                        children: [
                          SvgPicture.string(
                            '''
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                              <path d="M12,6a4,4,0,1,0,4,4A4,4,0,0,0,12,6Zm0,6a2,2,0,1,1,2-2A2,2,0,0,1,12,12Z"></path>
                              <path d="M12,24a5.271,5.271,0,0,1-4.311-2.2c-3.811-5.257-5.744-9.209-5.744-11.747a10.055,10.055,0,0,1,20.11,0c0,2.538-1.933,6.49-5.744,11.747A5.271,5.271,0,0,1,12,24ZM12,2.181a7.883,7.883,0,0,0-7.874,7.874c0,2.01,1.893,5.727,5.329,10.466a3.145,3.145,0,0,0,5.09,0c3.436-4.739,5.329-8.456,5.329-10.466A7.883,7.883,0,0,0,12,2.181Z"></path>
                            </svg>
                            ''',
                            width: 16.sp,
                            height: 16.sp,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 1.w),
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
                      SizedBox(height: 1.h),
                      // Dates
                      Row(
                        textDirection: ui.TextDirection.rtl,
                        children: [
                          SvgPicture.string(
                            '''
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                              <path d="M17,10.039c-3.859,0-7,3.14-7,7,0,3.838,3.141,6.961,7,6.961s7-3.14,7-7c0-3.838-3.141-6.961-7-6.961Zm0,11.961c-2.757,0-5-2.226-5-4.961,0-2.757,2.243-5,5-5s5,2.226,5,4.961c0,2.757-2.243,5-5,5Zm1.707-4.707c.391,.391,.391,1.023,0,1.414-.195,.195-.451,.293-.707,.293s-.512-.098-.707-.293l-1-1c-.188-.188-.293-.442-.293-.707v-2c0-.552,.447-1,1-1s1,.448,1,1v1.586l.707,.707Zm5.293-10.293v2c0,.552-.447,1-1,1s-1-.448-1-1v-2c0-1.654-1.346-3-3-3H5c-1.654,0-3,1.346-3,3v1H11c.552,0,1,.448,1,1s-.448,1-1,1H2v9c0,1.654,1.346,3,3,3h4c.552,0,1,.448,1,1s-.448,1-1,1H5c-2.757,0-5-2.243-5-5V7C0,4.243,2.243,2,5,2h1V1c0-.552,.448-1,1-1s1,.448,1,1v1h8V1c0-.552,.447-1,1-1s1,.448,1,1v1h1c2.757,0,5,2.243,5,5Z"></path>
                            </svg>
                            ''',
                            width: 16.sp,
                            height: 16.sp,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 1.w),
                          Flexible(
                            child: Wrap(
                              textDirection: ui.TextDirection.rtl,
                              spacing: 2.w,
                              children: [
                                Text(
                                  'from'.tr() +
                                      ': ${DateFormat('yyyy-MM-dd').format(tender.startDate)}',
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'to'.tr() +
                                      ': ${isSubscribed ? DateFormat('yyyy-MM-dd').format(tender.endDate) : 'restricted_info'.tr()}',
                                  style: TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                    fontWeight: isSubscribed
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
