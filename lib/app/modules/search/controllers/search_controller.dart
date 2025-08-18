import 'package:get/get.dart';

import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

import 'package:get/get.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

class SearchController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  var searchResults = <TenderModel>[].obs;
  var searchQuery = ''.obs;
  var selectedWilaya = ''.obs;
  var selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchTenders();
  }

  void searchTenders() {
    _firebaseService.getTenders().listen((tenderList) {
      searchResults.assignAll(
        tenderList.where((tender) {
          final matchesQuery =
              searchQuery.value.isEmpty ||
              tender.projectName.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              );
          final matchesWilaya =
              selectedWilaya.value.isEmpty ||
              tender.wilaya == selectedWilaya.value;
          final matchesCategory =
              selectedCategory.value.isEmpty ||
              tender.category == selectedCategory.value;
          return matchesQuery && matchesWilaya && matchesCategory;
        }).toList(),
      );
    });
  }
}
