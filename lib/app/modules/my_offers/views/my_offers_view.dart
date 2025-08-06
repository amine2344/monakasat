import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/theme_config.dart';
import '../controllers/my_offers_controller.dart';

class MyOffersView extends GetView<MyOffersController> {
  const MyOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.myOffers.length,
          itemBuilder: (context, index) {
            final offer = controller.myOffers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(offer.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('القطاع: ${offer.category}'),
                    Text('الولاية: ${offer.wilaya}'),
                    Text('التاريخ: ${offer.date}'),
                  ],
                ),
                onTap: () => Get.toNamed('/dashboard', arguments: offer),
              ),
            );
          },
        ),
      ),
    );
  }
}
