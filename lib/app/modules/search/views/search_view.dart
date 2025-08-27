import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'dart:ui' as ui;
import '../../../widgets/date_picker.dart';
import '../../../widgets/tender_item.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: ui.TextDirection.rtl,
                children: [
                  // Filter header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: ui.TextDirection.rtl,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.toggleFilters();
                        },
                        child: SvgPicture.string(
                          '''
                          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="21" x2="14" y1="4" y2="4"></line>
                            <line x1="10" x2="3" y1="4" y2="4"></line>
                            <line x1="21" x2="12" y1="12" y2="12"></line>
                            <line x1="8" x2="3" y1="12" y2="12"></line>
                            <line x1="21" x2="16" y1="20" y2="20"></line>
                            <line x1="12" x2="3" y1="20" y2="20"></line>
                            <line x1="14" x2="14" y1="2" y2="6"></line>
                            <line x1="8" x2="8" y1="10" y2="14"></line>
                            <line x1="16" x2="16" y1="18" y2="22"></line>
                          </svg>
                          ''',
                          width: 24,
                          height: 24,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'search_results'.tr(),
                        style: TextStyle(
                          fontFamily: 'NotoKufiArabic',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Divider(color: Colors.grey[300]),
                  SizedBox(height: 1.h),
                  // Filters
                  Obx(
                    () => Visibility(
                      visible: controller.showFilters.value,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 100.h, // Limit filter section height
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: ui.TextDirection.rtl,
                            children: [
                              // Search input
                              TextField(
                                onChanged: (value) {
                                  controller.searchQuery.value = value;
                                  controller.searchTenders();
                                },
                                decoration: InputDecoration(
                                  labelText: 'search'.tr(),
                                  hintText: 'search_by_keywords'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                style: const TextStyle(
                                  fontFamily: 'NotoKufiArabic',
                                ),
                                textDirection: ui.TextDirection.rtl,
                              ),
                              SizedBox(height: 1.h),
                              // Categories (multi-select)
                              MultiSelectDialogField(
                                items: controller.categories
                                    .map(
                                      (category) =>
                                          MultiSelectItem(category, category),
                                    )
                                    .toList(),
                                title: Text(
                                  'select_categories'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                  ),
                                ),
                                selectedColor: primaryColor,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                buttonText: Text(
                                  'select_categories'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                ),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                onConfirm: (values) {
                                  controller.selectedCategories.value = values
                                      .cast<String>();
                                  controller.searchTenders();
                                },
                              ),
                              SizedBox(height: 1.h),
                              // Tender type
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'tender_type'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                hint: Text(
                                  'select_tender_type'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                  ),
                                ),
                                value:
                                    controller.selectedTenderType.value.isEmpty
                                    ? null
                                    : controller.selectedTenderType.value,
                                isExpanded: true,
                                items: controller.tenderTypes
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: const TextStyle(
                                            fontFamily: 'NotoKufiArabic',
                                          ),
                                          textDirection: ui.TextDirection.rtl,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  controller.selectedTenderType.value =
                                      value ?? '';
                                  controller.searchTenders();
                                },
                              ),
                              SizedBox(height: 1.h),
                              // Wilayas (multi-select)
                              MultiSelectDialogField(
                                items: controller.wilayas
                                    .map(
                                      (wilaya) =>
                                          MultiSelectItem(wilaya, wilaya),
                                    )
                                    .toList(),
                                title: Text(
                                  'select_wilayas'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                  ),
                                ),
                                selectedColor: primaryColor,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                buttonText: Text(
                                  'select_wilayas'.tr(),
                                  style: const TextStyle(
                                    fontFamily: 'NotoKufiArabic',
                                  ),
                                  textDirection: ui.TextDirection.rtl,
                                ),
                                buttonIcon: const Icon(Icons.arrow_drop_down),
                                onConfirm: (values) {
                                  controller.selectedWilayas.value = values
                                      .cast<String>();
                                  controller.searchTenders();
                                },
                              ),
                              SizedBox(height: 1.h),
                              // Date range
                              DateRangePickerWidget(
                                selectedDateRange: controller.selectedDateRange,
                                onDateRangeChanged: (range) {
                                  controller.selectedDateRange.value = range;
                                  controller.searchTenders();
                                },
                                primaryColor: primaryColor,
                              ),
                              SizedBox(height: 1.h),
                              // Buttons
                              Row(
                                textDirection: ui.TextDirection.rtl,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.searchTenders();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 1.5.h,
                                      ),
                                    ),
                                    child: Text(
                                      'search'.tr(),
                                      style: const TextStyle(
                                        fontFamily: 'NotoKufiArabic',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  OutlinedButton(
                                    onPressed: () {
                                      controller.resetFilters();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: 1.5.h,
                                      ),
                                    ),
                                    child: Text(
                                      'reset'.tr(),
                                      style: TextStyle(
                                        fontFamily: 'NotoKufiArabic',
                                        color: Get.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),

          SliverFillRemaining(
            child: Obx(
              () => controller.searchResults.isEmpty
                  ? Column(
                      children: [
                        Center(
                          child: Text(
                            'no_results_found'.tr(),
                            style: const TextStyle(
                              fontFamily: 'NotoKufiArabic',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: controller.searchResults.length,
                      itemBuilder: (context, index) {
                        final tender = controller.searchResults[index];
                        final isProjectOwner =
                            FirebaseAuth.instance.currentUser?.uid ==
                            tender.userId;
                        return TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Opacity(opacity: value, child: child);
                          },
                          child: TenderItemWidget(
                            tender: tender,
                            isProjectOwner: isProjectOwner,
                            controller: homeController,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
