import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'notifications'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: primaryColor))
              : controller.notifications.isEmpty
              ? Center(
                  child: Text(
                    'no_notifications'.tr(),
                    style: TextStyle(
                      fontFamily: 'NotoKufiArabic',
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return Card(
                      margin: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 2.w,
                      ),
                      color: Get.theme.scaffoldBackgroundColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        leading: Icon(
                          Icons.notifications,
                          color: notification['read']
                              ? Colors.grey[600]
                              : primaryColor,
                          size: 20.sp,
                        ),
                        title: Text(
                          notification['title'],
                          style: TextStyle(
                            fontFamily: 'NotoKufiArabic',
                            fontSize: 14.sp,
                            fontWeight: notification['read']
                                ? FontWeight.normal
                                : FontWeight.w600,
                            color: notification['read']
                                ? Colors.grey[800]
                                : primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: ui.TextDirection.rtl,
                          children: [
                            SizedBox(height: 0.5.h),
                            Text(
                              notification['body'],
                              style: TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                                context.locale.languageCode,
                              ).format(
                                DateTime.parse(notification['receivedAt']),
                              ),
                              style: TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 10.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        trailing: !notification['read']
                            ? IconButton(
                                icon: Icon(
                                  Icons.mark_email_read,
                                  color: primaryColor,
                                  size: 16.sp,
                                ),
                                onPressed: () =>
                                    controller.markAsRead(notification['id']),
                              )
                            : null,
                        onTap: () {
                          controller.markAsRead(notification['id']);
                          if (notification['data'] != null &&
                              notification['data']['tenderId'] != null) {
                            final isProjectOwner =
                                controller.authController.selectedRole.value ==
                                'project_owner';
                            Get.toNamed(
                              isProjectOwner
                                  ? '/tender_details_owner'
                                  : '/tender_details_contractor',
                              arguments: {
                                'tenderId': notification['data']['tenderId'],
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
