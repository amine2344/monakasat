import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../../storage/app.storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/firebase_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseService firebaseService = Get.find<FirebaseService>();
  final AppStorage appStorage = AppStorage();
  var isLoading = false.obs;
  var selectedRole = 'contractor'.obs;
  var currentStep = 1.obs;
  RxBool isPasswordHide = true.obs;
  var user = Rxn<UserModel>();
  var confirmPassword = ''.obs;

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

  UserModel? get currentUser => user.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void togglePassHide() {
    isPasswordHide.value = !isPasswordHide.value;
    update();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final authUser = firebaseService.auth.currentUser;
      if (authUser != null) {
        UserModel? storedUser = await appStorage.getUser(authUser.uid);
        if (storedUser != null) {
          user.value = storedUser;
          selectedRole.value = storedUser.role;
          debugPrint('Loaded user from SharedPreferences: ${storedUser.email}');
        } else {
          final userDoc = await firebaseService.firestore
              .collection('users')
              .doc(authUser.uid)
              .get();
          if (userDoc.exists) {
            final userData = UserModel.fromJson(userDoc.data()!, authUser.uid);
            user.value = userData;
            selectedRole.value = userData.role;
            await appStorage.saveUser(authUser.uid, userData);
            debugPrint(
              'Loaded user from Firestore and saved to SharedPreferences: ${userData.email}',
            );
          } else {
            resetFields();
          }
        }
        _updateFcmToken(authUser.uid);
      } else {
        resetFields();
      }
    } catch (e) {
      debugPrint('ERROR LOADING USER DATA ==> ${e.toString()}');
      Get.showSnackbar(
        GetSnackBar(
          title: 'error'.tr(),
          message: 'failed_to_load_user_data'.tr(),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateFcmToken(String userId) async {
    try {
      final token = await firebaseService.messaging.getToken();
      if (token != null) {
        await firebaseService.firestore.collection('users').doc(userId).update({
          'deviceToken': token,
        });
        debugPrint('Updated FCM token for user $userId: $token');
      }
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
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
    user.value = null;
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
      final authUser = await firebaseService.login(email, password);
      if (authUser != null) {
        final userDoc = await firebaseService.firestore
            .collection('users')
            .doc(authUser.uid)
            .get();
        final userRole = userDoc.data()?['role'] ?? 'contractor';
        if (userRole == selectedRole.value) {
          final userData = UserModel.fromJson(userDoc.data()!, authUser.uid);
          user.value = userData;
          await appStorage.saveUser(authUser.uid, userData);
          Get.offAllNamed(Routes.DASHBOARD);
        } else {
          Get.showSnackbar(
            GetSnackBar(
              title: 'error'.tr(),
              message: 'role_mismatch'.tr(),
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
            ),
          );
          await firebaseService.signOut();
        }
      }
    } catch (e) {
      debugPrint('ERROR LOGIN ==> ${e.toString()}');
      Get.showSnackbar(
        GetSnackBar(
          title: 'error'.tr(),
          message: 'login_failed'.tr(),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
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
      final authUser = userCredential.user;
      if (authUser != null) {
        final userData = UserModel(
          id: authUser.uid,
          email: email.value,
          phone: phone.value,
          role: selectedRole.value,
          name: selectedRole.value == 'contractor' ? name.value : null,
          prename: selectedRole.value == 'contractor' ? prename.value : null,
          wilaya: selectedRole.value == 'contractor' ? wilaya.value : null,
          activitySector: selectedRole.value == 'contractor'
              ? activitySector.value
              : null,
          companyName: selectedRole.value == 'project_owner'
              ? companyName.value
              : null,
          companyAddress: selectedRole.value == 'project_owner'
              ? companyAddress.value
              : null,
          companyPhone: selectedRole.value == 'project_owner'
              ? companyPhone.value
              : null,
          createdAt: DateTime.now(),
          deviceToken: await firebaseService.messaging.getToken(),
          favorites: [],
          subscription: selectedRole.value == 'contractor' ? 'free' : null,
        );
        await firebaseService.firestore
            .collection('users')
            .doc(authUser.uid)
            .set(userData.toJson());
        user.value = userData;
        await appStorage.saveUser(authUser.uid, userData);
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'error'.tr(),
          message: 'signup_failed'.tr(),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
      debugPrint('ERROR SIGNUP ==> ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
