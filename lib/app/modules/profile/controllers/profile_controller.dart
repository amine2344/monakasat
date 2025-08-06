import 'package:get/get.dart';
import '../../../data/services/firebase_service.dart';

class ProfileController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    final user = _firebaseService.auth.currentUser;
    if (user != null) {
      final doc = await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .get();
      userData.value = doc.data() ?? {};
    }
  }

  void signOut() {
    _firebaseService.signOut();
    Get.offAllNamed('/login');
  }
}
