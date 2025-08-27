import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/models/tender_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AuthController authController = Get.find<AuthController>();
  var tenders = <TenderModel>[].obs;
  var favorites = <String>{}.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTenders();
    fetchFavorites();
  }

  void fetchTenders() {
    isLoading.value = true;
    try {
      firebaseService.getTenders().listen(
        (tenderList) {
          final isProjectOwner =
              authController.selectedRole.value == 'project_owner';
          tenders.assignAll(
            tenderList
                .where(
                  (tender) => isProjectOwner
                      ? tender.userId == firebaseService.auth.currentUser?.uid
                      : tender.stage == 'announced',
                )
                .toList(),
          );
        },
        onError: (e) {
          Get.snackbar('error'.tr(), 'failed_to_load_tenders'.tr());
          debugPrint('Error fetching tenders: $e');
          isLoading.value = false;
        },
      );
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('error'.tr(), 'failed_to_load_tenders'.tr());
      debugPrint('Error fetching tenders: $e');
      isLoading.value = false;
    }
  }

  void fetchFavorites() {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId != null) {
      isLoading.value = true;
      try {
        firebaseService.firestore
            .collection('users')
            .doc(userId)
            .snapshots()
            .listen(
              (doc) {
                if (doc.exists) {
                  favorites.value = Set<String>.from(
                    doc.data()?['favorites'] ?? [],
                  );
                }
                isLoading.value = false;
              },
              onError: (e) {
                Get.snackbar('error'.tr(), 'failed_to_load_favorites'.tr());
                debugPrint('Error fetching favorites: $e');
                isLoading.value = false;
              },
            );
      } catch (e) {
        Get.snackbar('error'.tr(), 'failed_to_load_favorites'.tr());
        debugPrint('Error fetching favorites: $e');
        isLoading.value = false;
      }
    }
  }

  Future<void> toggleFavorite(String tenderId) async {
    final userId = firebaseService.auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar('error'.tr(), 'user_not_authenticated'.tr());
      return;
    }
    try {
      if (favorites.contains(tenderId)) {
        favorites.remove(tenderId);
        await firebaseService.firestore.collection('users').doc(userId).update({
          'favorites': favorites.toList(),
        });
        Get.snackbar('success'.tr(), 'removed_from_favorites'.tr());
      } else {
        favorites.add(tenderId);
        await firebaseService.firestore.collection('users').doc(userId).update({
          'favorites': favorites.toList(),
        });
        Get.snackbar('success'.tr(), 'added_to_favorites'.tr());
      }
    } catch (e) {
      Get.snackbar('error'.tr(), 'favorite_update_failed'.tr());
      debugPrint('Error updating favorite: $e');
    }
  }
}
