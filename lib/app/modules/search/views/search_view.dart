import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart' hide Trans;
import '../../../routes/app_pages.dart';
import '../controllers/search_controller.dart';

import 'package:flutter/material.dart' hide SearchController;

import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'search_tenders'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.searchTenders();
              },
              decoration: InputDecoration(
                labelText: "search_tenders".tr(),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              style: const TextStyle(fontFamily: 'NotoKufiArabic'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text(
                'اختر الولاية'.tr(),
                style: const TextStyle(fontFamily: 'NotoKufiArabic'),
              ),
              value: controller.selectedWilaya.value.isEmpty
                  ? null
                  : controller.selectedWilaya.value,
              isExpanded: true,
              items:
                  [
                        'ولاية تبسة',
                        'ولاية الجزائر العاصمة',
                        'ولاية وهران',
                        'ولاية غليزان',
                        'ولاية بشار',
                        'Constantine', // Added to match provided data
                      ]
                      .map(
                        (wilaya) => DropdownMenuItem(
                          value: wilaya,
                          child: Text(
                            wilaya,
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                controller.selectedWilaya.value = value ?? '';
                controller.searchTenders();
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text(
                'اختر القطاع'.tr(),
                style: const TextStyle(fontFamily: 'NotoKufiArabic'),
              ),
              value: controller.selectedCategory.value.isEmpty
                  ? null
                  : controller.selectedCategory.value,
              isExpanded: true,
              items:
                  [
                        'أشغال البناء والهندسة المدنية',
                        'صناعات الصلب والمعادن ومواد البناء',
                        'الصناعة الكهربائية ,أشغال الكهرباء و الإنارة العمومية',
                        'الدراسات و الإستشارات',
                        'Consulting', // Added to match provided data
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                controller.selectedCategory.value = value ?? '';
                controller.searchTenders();
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => controller.searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'no_results_found'.tr(),
                          style: const TextStyle(fontFamily: 'NotoKufiArabic'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          final tender = controller.searchResults[index];
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Opacity(opacity: value, child: child);
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  tender.projectName,
                                  style: const TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('القطاع: ${tender.category ?? 'N/A'}'),
                                    Text('الولاية: ${tender.wilaya ?? 'N/A'}'),
                                    Text('الميزانية: ${tender.budget}'),
                                    Text(
                                      'التاريخ: ${DateFormat('yyyy-MM-dd').format(tender.createdAt)}',
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Get.toNamed(
                                    Routes.TENDER_DETAILS_CONTRACTOR,
                                    arguments: tender,
                                  );
                                },
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
