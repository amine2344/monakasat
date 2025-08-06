import 'package:get/get.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';

class MyOffersController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var myOffers = <TenderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyOffers();
  }

  void fetchMyOffers() {
    final user = _firebaseService.auth.currentUser;
    if (user != null) {
      _firebaseService.getTenders().listen((tenderList) {
        // Simulate filtering offers submitted by the user
        myOffers.assignAll(
          tenderList
              .where((tender) => tender.announcer.contains(user.email ?? ''))
              .toList(),
        );
      });
    }
  }
}
