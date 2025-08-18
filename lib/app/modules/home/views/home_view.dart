import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:sizer/sizer.dart';
import '../../../controllers/theme_controller.dart';
import '../../search/views/search_view.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final isProjectOwner = authController.selectedRole.value == 'project_owner';

    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        trailing: IconButton(
          icon: Icon(Icons.search, color: lightColor, size: 20.sp),
          onPressed: () => Get.toNamed(Routes.SEARCH),
        ),
        title: Text(
          'available_tenders'.tr(),
          style: const TextStyle(
            color: lightColor,
            fontFamily: 'NotoKufiArabic',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: SafeArea(
          child: Obx(
            () => controller.tenders.isEmpty
                ? Center(
                    child: Text(
                      'no_tenders_available'.tr(),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: controller.tenders.length,
                    itemBuilder: (context, index) {
                      final tender = controller.tenders[index];
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: Container(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(4.0),
                              title: Text(
                                tender.projectName.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                  fontWeight: FontWeight.w600,

                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'category'.tr(
                                      args: [tender.category ?? 'N/A'],
                                    ),
                                  ),
                                  Text(
                                    'wilaya'.tr(args: [tender.wilaya ?? 'N/A']),
                                  ),
                                  Text(
                                    'budget'.tr(
                                      args: [tender.budget.toString()],
                                    ),
                                  ),
                                  Text(
                                    'date'.tr(
                                      args: [
                                        DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(tender.createdAt),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'announcer'.tr(
                                      args: [tender.announcer ?? 'Unknown'],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Obx(
                                () => IconButton(
                                  icon: Icon(
                                    controller.favorites.contains(tender.id)
                                        ? Icons.history
                                        : Icons.history_toggle_off_outlined,
                                    color: primaryColor,
                                  ),
                                  onPressed: () =>
                                      controller.toggleFavorite(tender.id),
                                ),
                              ),
                              onTap: () {
                                Get.toNamed(
                                  isProjectOwner
                                      ? Routes.TENDER_DETAILS_OWNER
                                      : Routes.TENDER_DETAILS_CONTRACTOR,
                                  arguments: tender,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
