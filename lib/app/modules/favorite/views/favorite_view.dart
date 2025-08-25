import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;
import '../../../controllers/theme_controller.dart';
import '../../../widgets/tender_item.dart';
import '../../home/controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/favorite_controller.dart';

class FavoriteView extends GetView<FavoriteController> {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();
    final HomeController homeController = Get.find<HomeController>();
    final isProjectOwner = authController.selectedRole.value == 'project_owner';

    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        titleText: 'favorite'.tr(),
        backgroundColor: primaryColor,
      ),
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: CustomScrollView(
          slivers: [
            /* SliverToBoxAdapter(
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
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                          </svg>
                          ''',
                          width: 24,
                          height: 24,
                          color: primaryColor,
                        ),
                        Text(
                          'favorite'.tr(),
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
             */
            SliverFillRemaining(
              child: Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : controller.favoriteTenders.isEmpty
                    ? Center(
                        child: Text(
                          'no_favorites_available'.tr(),
                          style: TextStyle(
                            fontFamily: 'NotoKufiArabic',
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(4.w),
                        itemCount: controller.favoriteTenders.length,
                        itemBuilder: (context, index) {
                          final tender = controller.favoriteTenders[index];
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Opacity(opacity: value, child: child);
                            },
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  isProjectOwner
                                      ? Routes.TENDER_DETAILS_OWNER
                                      : Routes.TENDER_DETAILS_CONTRACTOR,
                                  arguments: tender,
                                );
                              },
                              child: TenderItemWidget(
                                tender: tender,
                                isProjectOwner: isProjectOwner,
                                controller: homeController,
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
}
