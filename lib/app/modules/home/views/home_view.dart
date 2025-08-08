import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
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
        trailing: Icon(Icons.search, color: lightColor),
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
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            tender.projectName,
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('category'.tr(args: [tender.serviceType])),
                              Text('wilaya'.tr(args: [tender.wilaya ?? 'N/A'])),
                              Text(
                                'date'.tr(
                                  args: [
                                    tender.createdAt.toString().substring(
                                      0,
                                      10,
                                    ),
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
                          trailing: IconButton(
                            icon: Icon(
                              controller.favorites.contains(tender.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: primaryColor,
                            ),
                            onPressed: () =>
                                controller.toggleFavorite(tender.id),
                          ),
                          onTap: () {
                            Get.toNamed(
                              isProjectOwner
                                  ? '/tender_details_owner'
                                  : '/tender_details_contractor',
                              arguments: tender,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
      /* floatingActionButton: isProjectOwner
          ? FloatingActionButton(
              onPressed: () => Get.toNamed('/planning'),
              backgroundColor: primaryColor,
              tooltip: 'add_project'.tr(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, */
    );
  }
}
