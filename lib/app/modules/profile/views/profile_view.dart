import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:mounakassat_dz/app/data/models/user_model.dart';
import 'package:sizer/sizer.dart';
import 'package:mounakassat_dz/utils/theme_config.dart';
import 'package:mounakassat_dz/app/controllers/theme_controller.dart';
import 'package:mounakassat_dz/app/widgets/custom_button.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AuthController authController = Get.find<AuthController>();

    final isUserLoggedIn = authController.currentUser != null;

    return Scaffold(
      body: Directionality(
        textDirection: themeController.textDirection.value,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(2.w),
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
    final user =
        authController.currentUser ??
        UserModel(id: '', email: '', phone: '', role: '');
    final isProjectOwner = user.role == 'project_owner';
    final favorites = user.favorites?.isNotEmpty ?? false
        ? user.favorites!.join(', ')
        : 'no_favorites'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20.w,
          backgroundColor: Colors.grey[300],
          child: user.profilePhotoUrl?.isNotEmpty ?? false
              ? ClipOval(
                  child: Image.network(
                    user.profilePhotoUrl!,
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 20.w, color: Colors.grey),
                  ),
                )
              : Icon(Icons.person, size: 20.w, color: Colors.grey),
        ),
        SizedBox(height: 2.h),
        Text(
          'welcome'.tr(),
          style: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          user.userName.isNotEmpty ? user.userName.toUpperCase() : 'N/A',
          style: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.all(4.w),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileItem(
                  context,
                  label: 'email'.tr(),
                  value: user.email.isNotEmpty ? user.email : 'N/A',
                ),
                _buildProfileItem(
                  context,
                  label: 'phone'.tr(),
                  value: user.phone.isNotEmpty ? user.phone : 'N/A',
                ),
                if (isProjectOwner) ...[
                  _buildProfileItem(
                    context,
                    label: 'company_name'.tr(),
                    value: user.companyName?.isNotEmpty ?? false
                        ? user.companyName!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'company_address'.tr(),
                    value: user.companyAddress?.isNotEmpty ?? false
                        ? user.companyAddress!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'company_phone'.tr(),
                    value: user.companyPhone?.isNotEmpty ?? false
                        ? user.companyPhone!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'created_at'.tr(),
                    value: user.createdAt != null
                        ? DateFormat(
                            'yyyy-MM-dd',
                            context.locale.languageCode,
                          ).format(user.createdAt!)
                        : 'N/A',
                  ),
                ] else ...[
                  _buildProfileItem(
                    context,
                    label: 'name'.tr(),
                    value: user.name?.isNotEmpty ?? false ? user.name! : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'prename'.tr(),
                    value: user.prename?.isNotEmpty ?? false
                        ? user.prename!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'company_name'.tr(),
                    value: user.companyName?.isNotEmpty ?? false
                        ? user.companyName!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'wilaya'.tr(),
                    value: user.wilaya?.isNotEmpty ?? false
                        ? user.wilaya!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'activity_sector'.tr(),
                    value: user.activitySector?.isNotEmpty ?? false
                        ? user.activitySector!
                        : 'N/A',
                  ),
                  _buildProfileItem(
                    context,
                    label: 'subscription'.tr(),
                    value: user.subscription?.isNotEmpty ?? false
                        ? user.subscription!
                        : 'N/A',
                  ),
                ],
                /* _buildProfileItem(
                  context,
                  label: 'favorites'.tr(),
                  value: favorites,
                ), */
                _buildProfileItem(
                  context,
                  label: 'role'.tr(),
                  value: user.role.tr(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 3.h),
        CustomButton(
          text: 'edit_profile'.tr(),
          trailingIcon: Icons.edit,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          iconColor: Colors.white,
          fixedSize: Size(90.w, 8.h),
          borderRadius: 8,
          onPressed: () {
            Get.snackbar('edit_profile'.tr(), 'edit_profile_coming_soon'.tr());
          },
        ),
        SizedBox(height: 2.h),
        CustomButton(
          text: 'logout'.tr(),
          trailingIcon: Icons.logout,
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          textColor: primaryColor,
          iconColor: primaryColor,
          borderSide: BorderSide(color: primaryColor),
          fixedSize: Size(90.w, 8.h),
          borderRadius: 8,
          onPressed: () async {
            await authController.appStorage.clearUser(
              authController.currentUser!.id,
            );
            await authController.firebaseService.signOut();
            authController.resetFields();
            Get.offAllNamed(Routes.DASHBOARD);
          },
          textStyle: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 2.h),
        CircleAvatar(
          radius: 20.w,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: 20.w, color: Colors.grey),
        ),
        SizedBox(height: 2.h),
        Text(
          'welcome'.tr(),
          style: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'guest_user'.tr().toUpperCase(),
          style: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 30.h),
        CustomButton(
          text: 'login'.tr(),
          trailingIcon: Icons.login,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          iconColor: Colors.white,
          fixedSize: Size(90.w, 8.h),
          borderRadius: 8,
          onPressed: () => Get.toNamed(Routes.AUTH),
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
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'NotoKufiArabic',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'NotoKufiArabic',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
