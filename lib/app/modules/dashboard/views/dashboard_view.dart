import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/modules/dashboard/views/drawer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../../widgets/custom_appbar.dart';
import '../../home/views/home_view.dart';
import '../../my_offers/views/my_offers_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/dashboard_controller.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      _buildTenderStagesView(context),
      const MyOffersView(),
      const SettingsView(),
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
        body: Directionality(
          textDirection: Get.find<ThemeController>().textDirection.value,
          child: pages[controller.selectedIndex.value],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: 'dashboard'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_offer),
              label: 'my_offers'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'settings'.tr(),
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
