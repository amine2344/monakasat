import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controllers/theme_controller.dart';
import '../../../data/models/tender_model.dart';
import '../../../widgets/tender_item.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final isProjectOwner = authController.selectedRole.value == 'project_owner';
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: Directionality(
        textDirection: Get.find<ThemeController>().textDirection.value,
        child: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      padding: EdgeInsets.all(4.w),
                      itemCount: 5, // Show 5 skeleton cards
                      itemBuilder: (context, index) {
                        return TenderItemWidget(
                          tender: TenderModel(
                            id: 'skeleton_$index',
                            userId: '',
                            projectName: 'Placeholder Project',
                            serviceType: 'Placeholder Type',
                            requirements: '',
                            budget: 0.0,
                            legalRequirements: '',
                            startDate: DateTime.now(),
                            endDate: DateTime.now(),
                            createdAt: DateTime.now(),
                            stage: 'announced',
                          ),
                          isProjectOwner: isProjectOwner,
                          controller: controller,
                        );
                      },
                    ),
                  )
                : controller.tenders.isEmpty
                ? Center(
                    child: Text(
                      'no_tenders_available'.tr(),
                      style: TextStyle(
                        fontFamily: 'NotoKufiArabic',
                        fontSize: 18.sp,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: controller.tenders.length,
                    itemBuilder: (context, index) {
                      final tender = controller.tenders[index];
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: TenderItemWidget(
                          tender: tender,
                          isProjectOwner: isProjectOwner,
                          controller: controller,
                        ),
                      );
                    },
                  ).paddingOnly(bottom: 4.h),
          ),
        ),
      ),
    );
  }
}
