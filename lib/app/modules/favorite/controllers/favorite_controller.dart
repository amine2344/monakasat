import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/tender_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class FavoriteController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final AuthController authController = Get.find<AuthController>();
  var favoriteTenders = <TenderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFavoriteTenders();
    });
  }

  void fetchFavoriteTenders() {
    isLoading.value = true;

    homeController.fetchTenders();
    homeController.tenders.listen((tenderList) {
      final favoriteIds = homeController.favorites;
      favoriteTenders.assignAll(
        tenderList.where((tender) => favoriteIds.contains(tender.id)).toList(),
      );
      isLoading.value = false;
    });
  }
}
