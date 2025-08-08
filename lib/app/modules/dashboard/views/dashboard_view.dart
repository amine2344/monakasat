import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/modules/dashboard/views/drawer.dart';
import 'package:mounakassat_dz/app/modules/notifications/views/notifications_view.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_appbar.dart';
import '../../home/views/home_view.dart';
import '../../my_offers/views/my_offers_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final List<Widget> pages = [
      const HomeView(),
      const MyOffersView(),
      const NotificationsView(),
      const ProfileView(),
    ];

    return Obx(
      () => Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          fromDash: true,
          endDrawerIcon: Icons.menu,
          centerTitle: false,
          onEndDrawerPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
        ),
        endDrawer: CustomDrawer(),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Stack(
          children: [
            Directionality(
              textDirection: Get.find<ThemeController>().textDirection.value,
              child: pages[controller.selectedIndex.value],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Obx(
                () => Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(25),
                  color:
                      Theme.of(
                        context,
                      ).bottomNavigationBarTheme.backgroundColor ??
                      Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BottomNavigationBar(
                      backgroundColor: Colors.transparent,
                      currentIndex: controller.selectedIndex.value,
                      onTap: controller.changeTab,
                      selectedItemColor: Theme.of(context).primaryColor,
                      unselectedItemColor:
                          Theme.of(
                            context,
                          ).bottomNavigationBarTheme.unselectedItemColor ??
                          Colors.grey,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      items: [
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.home),
                          label: 'home'.tr(),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.local_offer),
                          label: 'my_offers'.tr(),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.notifications),
                          label: 'notifications'.tr(),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.person),
                          label: 'profile'.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenderStagesView(BuildContext context) {
    return Obx(
      () => controller.tender.value == null
          ? Center(child: Text('no_tender_selected'.tr()))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'tender_stages'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'NotoKufiArabic',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ...controller.stages.map(
                  (stage) => TimelineTile(
                    alignment: TimelineAlign.center,
                    isFirst: controller.stages.first == stage,
                    isLast: controller.stages.last == stage,
                    indicatorStyle: IndicatorStyle(
                      color: stage.status == 'completed'
                          ? Colors.green
                          : stage.status == 'in_progress'
                          ? Colors.blue
                          : Colors.grey,
                      width: 30,
                    ),
                    beforeLineStyle: LineStyle(
                      color: stage.status == 'completed'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    afterLineStyle: LineStyle(
                      color: stage.status == 'completed'
                          ? Colors.green
                          : Colors.grey,
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            stage.stageName.tr(),
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text('الحالة: ${stage.status.tr()}'),
                          onTap: () => controller.navigateToStage(stage),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
