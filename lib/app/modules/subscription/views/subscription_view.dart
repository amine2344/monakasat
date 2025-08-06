import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionView extends GetView<SubscriptionController> {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.packages.length,
          itemBuilder: (context, index) {
            final package = controller.packages[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(package['name']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('السعر: ${package['price']}'),
                    Text('التفاصيل: ${package['details']}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Implement subscription logic
                    Get.snackbar('إشتراك', 'تم تحديد باقة ${package['name']}');
                  },
                  child: const Text('إشترك'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
