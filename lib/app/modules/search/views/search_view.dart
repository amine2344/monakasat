import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.searchTenders();
              },
              decoration: const InputDecoration(labelText: 'ابحث عن مناقصة'),
            ),
            DropdownButton<String>(
              hint: const Text('اختر الولاية'),
              value: controller.selectedWilaya.value.isEmpty
                  ? null
                  : controller.selectedWilaya.value,
              items:
                  [
                        'ولاية تبسة',
                        'ولاية الجزائر العاصمة',
                        'ولاية وهران',
                        'ولاية غليزان',
                        'ولاية بشار',
                      ]
                      .map(
                        (wilaya) => DropdownMenuItem(
                          value: wilaya,
                          child: Text(wilaya),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                controller.selectedWilaya.value = value ?? '';
                controller.searchTenders();
              },
            ),
            DropdownButton<String>(
              hint: const Text('اختر القطاع'),
              value: controller.selectedCategory.value.isEmpty
                  ? null
                  : controller.selectedCategory.value,
              items:
                  [
                        'أشغال البناء والهندسة المدنية',
                        'صناعات الصلب والمعادن ومواد البناء',
                        'الصناعة الكهربائية ,أشغال الكهرباء و الإنارة العمومية',
                        'الدراسات و الإستشارات',
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                controller.selectedCategory.value = value ?? '';
                controller.searchTenders();
              },
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final tender = controller.searchResults[index];
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
                          ],
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
