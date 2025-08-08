import 'package:get/get.dart';

import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

class SearchController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var searchResults = <TenderModel>[].obs;
  var searchQuery = ''.obs;
  var selectedWilaya = ''.obs;
  var selectedCategory = ''.obs;

  void searchTenders() {
    _firebaseService.getTenders().listen((tenderList) {
      /* searchResults.assignAll(
        tenderList
            .where(
              (tender) =>
                  tender.title.contains(searchQuery.value) &&
                  (selectedWilaya.value.isEmpty ||
                      tender.wilaya == selectedWilaya.value) &&
                  (selectedCategory.value.isEmpty ||
                      tender.category == selectedCategory.value),
            )
            .toList(),
      ); */
    });
  }
}
