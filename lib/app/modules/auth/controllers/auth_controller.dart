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
  var profilePhotoUrl = ''.obs;
  var confirmPassword = ''.obs;

  var currentStep = 1.obs;
  RxBool isPasswordHide = true.obs;
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

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void togglePassHide() {
    isPasswordHide.value = !isPasswordHide.value;
    update();
  }

  Future<void> _loadUserData() async {
    try {
      final user = firebaseService.auth.currentUser;
      if (user != null) {
        final userDoc = await firebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final data = userDoc.data()!;
          email.value = data['email'] ?? '';
          phone.value = data['phone'] ?? '';
          selectedRole.value = data['role'] ?? 'contractor';
          profilePhotoUrl.value = data['profilePhotoUrl'] ?? '';
          if (selectedRole.value == 'contractor') {
            name.value = data['name'] ?? '';
            prename.value = data['prename'] ?? '';
            wilaya.value = data['wilaya'] ?? '';
            activitySector.value = data['activitySector'] ?? '';
          } else {
            companyName.value = data['companyName'] ?? '';
            companyAddress.value = data['companyAddress'] ?? '';
            companyPhone.value = data['companyPhone'] ?? '';
          }
        } else {
          // No user data in Firestore, reset fields
          resetFields();
        }
      } else {
        // No user logged in, reset fields
        resetFields();
      }
    } catch (e) {
      debugPrint('ERROR LOADING USER DATA ==> ${e.toString()}');
      Get.snackbar('خطأ'.tr(), 'failed_to_load_user_data'.tr());
      resetFields();
    }
  }

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
    profilePhotoUrl.value = '';
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
          final token = await firebaseService.messaging.getToken();
          if (token != null) {
            await firebaseService.firestore
                .collection('users')
                .doc(user.uid)
                .update({'deviceToken': token});
          }
          await _loadUserData();
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          Get.snackbar('خطأ'.tr(), 'role_mismatch'.tr());
          await firebaseService.signOut();
        }
      }
    } catch (e) {
      debugPrint('ERROR LOGIN ==> ${e.toString()}');
      Get.snackbar('خطأ'.tr(), 'login_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    isLoading.value = true;
    try {
      final userCredential = await firebaseService.auth
          .createUserWithEmailAndPassword(
            email: email.value,
            password: password.value,
          );
      final user = userCredential.user;
      if (user != null) {
        await firebaseService.firestore.collection('users').doc(user.uid).set({
          'email': email.value,
          'phone': phone.value,
          'role': selectedRole.value,
          if (selectedRole.value == 'contractor') ...{
            'name': name.value,
            'prename': prename.value,
            'wilaya': wilaya.value,
            'activitySector': activitySector.value,
          } else ...{
            'companyName': companyName.value,
            'companyAddress': companyAddress.value,
            'companyPhone': companyPhone.value,
          },
          'createdAt': DateTime.now(),
        });
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      Get.snackbar('error'.tr(), 'signup_failed'.tr());
    } finally {
      isLoading.value = false;
    }
  }
}
