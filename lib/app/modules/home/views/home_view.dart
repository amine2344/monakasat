import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mounakassat_dz/app/widgets/custom_appbar.dart';

import '../../../../utils/theme_config.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.tenders.length,
          itemBuilder: (context, index) {
            final tender = controller.tenders[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(tender.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('القطاع: ${tender.category}'),
                    Text('الولاية: ${tender.wilaya}'),
                    Text('التاريخ: ${tender.date}'),
                    Text('المعلن: ${tender.announcer}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // Add to favorites logic
                  },
                ),
                onTap: () => Get.toNamed('/dashboard', arguments: tender),
              ),
            );
          },
        ),
      ),
    );
  }
}
