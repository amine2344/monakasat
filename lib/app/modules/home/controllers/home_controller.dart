import 'package:get/get.dart';

import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var tenders = <TenderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTenders();
  }

  void fetchTenders() {
    _firebaseService.getTenders().listen((tenderList) {
      tenders.assignAll(tenderList);
    });
  }
}
