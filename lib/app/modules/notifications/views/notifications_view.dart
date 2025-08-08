import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';

import '../../../controllers/theme_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'notifications'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.notifications.isEmpty
              ? Center(
                  child: Text(
                    'no_notifications'.tr(),
                    style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: notification['read']
                          ? Colors.white
                          : Colors.grey[200],
                      child: ListTile(
                        title: Text(
                          notification['title'],
                          style: TextStyle(
                            fontFamily: 'NotoKufiArabic',
                            fontWeight: notification['read']
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['body'],
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                              ),
                            ),
                            Text(
                              DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(notification['receivedAt'].toDate()),
                              style: const TextStyle(
                                fontFamily: 'NotoKufiArabic',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: !notification['read']
                            ? IconButton(
                                icon: const Icon(
                                  Icons.mark_email_read,
                                  color: primaryColor,
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
