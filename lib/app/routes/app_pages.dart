import 'package:get/get.dart';

import '../modules/announce/bindings/announce_binding.dart';
import '../modules/announce/views/announce_view.dart';
import '../modules/approve_contract/bindings/approve_contract_binding.dart';
import '../modules/approve_contract/views/approve_contract_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/evaluate_offers/bindings/evaluate_offers_binding.dart';
import '../modules/evaluate_offers/views/evaluate_offers_view.dart';
import '../modules/execution/bindings/execution_binding.dart';
import '../modules/execution/views/execution_view.dart';
import '../modules/final_delivery/bindings/final_delivery_binding.dart';
import '../modules/final_delivery/views/final_delivery_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/my_offers/bindings/my_offers_binding.dart';
import '../modules/my_offers/views/my_offers_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/open_envloppes/bindings/open_envloppes_binding.dart';
import '../modules/open_envloppes/views/open_envloppes_view.dart';
import '../modules/planning/bindings/planning_binding.dart';
import '../modules/planning/views/planning.step1.view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/submit_offers/bindings/submit_offers_binding.dart';
import '../modules/submit_offers/views/submit_offers_view.dart';
import '../modules/subscription/bindings/subscription_binding.dart';
import '../modules/subscription/views/subscription_view.dart';
import '../modules/tender_details_contractor/bindings/tender_details_contractor_binding.dart';
import '../modules/tender_details_contractor/views/tender_details_contractor_view.dart';
import '../modules/tender_details_owner/bindings/tender_details_owner_binding.dart';
import '../modules/tender_details_owner/views/tender_details_owner_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTION,
      page: () => const SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MY_OFFERS,
      page: () => const MyOffersView(),
      binding: MyOffersBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.PLANNING,
      page: () => const PlanningStep1View(),
      binding: PlanningBinding(),
    ),
    GetPage(
      name: _Paths.ANNOUNCE,
      page: () => const AnnounceView(),
      binding: AnnounceBinding(),
    ),
    GetPage(
      name: _Paths.SUBMIT_OFFERS,
      page: () => const SubmitOffersView(),
      binding: SubmitOffersBinding(),
    ),
    GetPage(
      name: _Paths.OPEN_ENVLOPPES,
      page: () => const OpenEnvelopesView(),
      binding: OpenEnvloppesBinding(),
    ),
    GetPage(
      name: _Paths.EVALUATE_OFFERS,
      page: () => const EvaluateOffersView(),
      binding: EvaluateOffersBinding(),
    ),
    GetPage(
      name: _Paths.APPROVE_CONTRACT,
      page: () => const ApproveContractView(),
      binding: ApproveContractBinding(),
    ),
    GetPage(
      name: _Paths.EXECUTION,
      page: () => const ExecutionView(),
      binding: ExecutionBinding(),
    ),
    GetPage(
      name: _Paths.FINAL_DELIVERY,
      page: () => const FinalDeliveryView(),
      binding: FinalDeliveryBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.TENDER_DETAILS_OWNER,
      page: () => const TenderDetailsOwnerView(),
      binding: TenderDetailsOwnerBinding(),
    ),
    GetPage(
      name: _Paths.TENDER_DETAILS_CONTRACTOR,
      page: () => const TenderDetailsContractorView(),
      binding: TenderDetailsContractorBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
