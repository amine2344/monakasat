import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../controllers/my_offers_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class MyOffersView extends GetView<MyOffersController> {
  const MyOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();
    final isProjectOwner = authController.selectedRole.value == 'project_owner';

    return Scaffold(
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.myOffers.isEmpty
                ? Center(
                    child: Text(
                      'no_offers_available'.tr(),
                      style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: controller.myOffers.length,
                    itemBuilder: (context, index) {
                      final tender = controller.myOffers[index];
                      /* final offerCount = tender.offers?.length ?? 0;
                      final userOffer = tender.offers?.firstWhereOrNull(
                        (offer) =>
                            offer['contractorId'] ==
                            authController
                                .firebaseService
                                .auth
                                .currentUser
                                ?.uid,
                      ); */

                      return Card(
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
                              /* Text('category'.tr(args: [tender.category])),
                              Text('wilaya'.tr(args: [tender.wilaya])),
                              Text('date'.tr(args: [tender.date])), */
                              Text(
                                'stage'.tr(
                                  args: [controller.getStageText(tender.stage)],
                                ),
                              ),
                              /* if (isProjectOwner)
                                Text(
                                  'offers_received'.tr(
                                    args: [offerCount.toString()],
                                  ),
                                )
                              else if (userOffer != null)
                                Text(
                                  'offer_status'.tr(
                                    args: [
                                      userOffer['status'] ?? 'pending'.tr(),
                                    ],
                                  ),
                                ), */
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: primaryColor,
                          ),
                          onTap: () {
                            controller.trackInteraction(
                              tender.id,
                              'view_tender_details',
                            );
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: isProjectOwner
          ? Padding(
              padding: EdgeInsets.only(bottom: 12.h, left: 5.w, right: 5.w),
              child: FloatingActionButton(
                onPressed: () => Get.toNamed(Routes.PLANNING),
                backgroundColor: primaryColor,
                tooltip: 'add_project'.tr(),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
