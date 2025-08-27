import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/theme_config.dart';
import '../../../controllers/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../widgets/custom_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();

    final isUserLoggedIn =
        authController.firebaseService.auth.currentUser != null;

    return Scaffold(
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: isUserLoggedIn
                ? Obx(() => _buildAuthenticatedView(context, authController))
                : _buildGuestView(context),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(
    BuildContext context,
    AuthController authController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile Photo Placeholder
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          child:
              (authController.user.value?.profilePhotoUrl?.isNotEmpty ?? false)
              ? ClipOval(
                  child: Image.network(
                    authController.user.value!.profilePhotoUrl!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                )
              : const Icon(Icons.person, size: 60, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          'welcome'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          authController.name.value.isNotEmpty
              ? authController.name.value
              : 'N/A',
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileItem(
                context,
                label: 'email'.tr(),
                value: authController.email.value.isNotEmpty
                    ? authController.email.value
                    : 'N/A',
              ),
              _buildProfileItem(
                context,
                label: 'name'.tr(),
                value: authController.name.value.isNotEmpty
                    ? authController.name.value
                    : 'N/A',
              ),
              _buildProfileItem(
                context,
                label: 'prename'.tr(),
                value: authController.prename.value.isNotEmpty
                    ? authController.prename.value
                    : 'N/A',
              ),
              _buildProfileItem(
                context,
                label: 'phone'.tr(),
                value: authController.phone.value.isNotEmpty
                    ? authController.phone.value
                    : 'N/A',
              ),
              if (authController.companyName.value.isNotEmpty)
                _buildProfileItem(
                  context,
                  label: 'company_name'.tr(),
                  value: authController.companyName.value,
                ),
              _buildProfileItem(
                context,
                label: 'wilaya'.tr(),
                value: authController.wilaya.value.isNotEmpty
                    ? authController.wilaya.value
                    : 'N/A',
              ),
              _buildProfileItem(
                context,
                label: 'activity_sector'.tr(),
                value: authController.activitySector.value.isNotEmpty
                    ? authController.activitySector.value
                    : 'N/A',
              ),
              _buildProfileItem(
                context,
                label: 'role'.tr(),
                value: authController.selectedRole.value.isNotEmpty
                    ? authController.selectedRole.value.tr()
                    : 'N/A',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Edit Profile Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'edit_profile'.tr(),
              trailingIcon: Icons.edit,
              backgroundColor: primaryColor,
              textColor: Colors.white,
              iconColor: Colors.white,
              fixedSize: Size(90.w, 8.h),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              borderRadius: 8,
              onPressed: () {
                Get.snackbar(
                  'edit_profile'.tr(),
                  'edit_profile_coming_soon'.tr(),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Logout Button
        CustomButton(
          text: 'logout'.tr(),
          trailingIcon: Icons.logout,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          textColor: primaryColor,
          iconColor: primaryColor,
          borderSide: BorderSide(color: primaryColor),
          fixedSize: Size(90.w, 8.h),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          borderRadius: 8,
          onPressed: () async {
            await authController.firebaseService.signOut();
            Get.offAllNamed(Routes.DASHBOARD);
          },
          textStyle: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        // Profile Photo Placeholder
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 60, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Text(
          'welcome'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'guest_user'.tr(),
          style: const TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 30.h),
        // Login Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'login'.tr(),
              trailingIcon: Icons.login,
              backgroundColor: primaryColor,
              textColor: Colors.white,
              iconColor: Colors.white,
              fixedSize: Size(90.w, 8.h),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              borderRadius: 8,
              onPressed: () {
                Get.toNamed(Routes.AUTH);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'NotoKufiArabic',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
