import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../data/services/firebase_service.dart';

import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseService firebaseService = FirebaseService();
  var isLoading = false.obs;
  var selectedRole = 'contractor'.obs;
  var currentStep = 1.obs;

  // Step 1 fields
  var email = ''.obs;
  var phone = ''.obs;
  var password = ''.obs;

  // Step 2 fields (Contractor)
  var name = ''.obs;
  var prename = ''.obs;
  var wilaya = ''.obs;
  var activitySector = ''.obs;

  // Step 2 fields (Project Owner)
  var companyName = ''.obs;
  var companyAddress = ''.obs;
  var companyPhone = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
    resetFields();
  }

  void resetFields() {
    email.value = '';
    phone.value = '';
    password.value = '';
    name.value = '';
    prename.value = '';
    wilaya.value = '';
    activitySector.value = '';
    companyName.value = '';
    companyAddress.value = '';
    companyPhone.value = '';
    currentStep.value = 1;
  }

  void nextStep() {
    currentStep.value++;
  }

  void previousStep() {
    currentStep.value--;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await firebaseService.login(email, password);
      if (user != null) {
        final userDoc = await firebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .get();
        final userRole = userDoc.data()?['role'] ?? 'contractor';
        if (userRole == selectedRole.value) {
          // Register device token
          final token = await firebaseService.messaging.getToken();
          if (token != null) {
            await firebaseService.firestore
                .collection('users')
                .doc(user.uid)
                .update({'deviceToken': token});
          }
          /* if (userRole == 'contractor') {
            Get.offAllNamed(Routes.MY_OFFERS);
          } else { */
          Get.offAllNamed(Routes.DASHBOARD);
          /* } */
        } else {
          Get.snackbar('خطأ'.tr(), 'role_mismatch'.tr());
          await firebaseService.signOut();
        }
      }
    } catch (e) {
      debugPrint('EROR LOGIN ===> ${e.toString()}');
      Get.snackbar('خطأ'.tr(), 'login_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final user = await firebaseService.signUp(
        email.value,
        password.value,
        selectedRole.value == 'contractor'
            ? '$prename $name'
            : companyName.value,
        selectedRole.value,
      );
      if (user != null) {
        // Save additional info
        final userData = {
          'email': email.value,
          'phone': phone.value,
          'role': selectedRole.value,
          'subscription': 'free',
        };
        if (selectedRole.value == 'contractor') {
          userData.addAll({
            'name': name.value,
            'prename': prename.value,
            'wilaya': wilaya.value,
            'activitySector': activitySector.value,
          });
        } else {
          userData.addAll({
            'companyName': companyName.value,
            'companyAddress': companyAddress.value,
            'companyPhone': companyPhone.value,
          });
        }
        await firebaseService.firestore
            .collection('users')
            .doc(user.user?.uid)
            .set(userData, SetOptions(merge: true));

        // Register device token
        final token = await firebaseService.messaging.getToken();
        if (token != null) {
          await firebaseService.firestore
              .collection('users')
              .doc(user.user?.uid)
              .update({'deviceToken': token});
        }

        Get.offAllNamed(
          /* selectedRole.value == 'contractor'
              ? Routes.MY_OFFERS
              : */
          Routes.DASHBOARD,
        );
      }
    } catch (e) {
      debugPrint('EROR ===> ${e.toString()}');
      Get.snackbar('خطأ'.tr(), '${'signup_failed'.tr()}${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
