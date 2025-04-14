import 'package:get/get.dart';

import '../modules/Activejob_screen/bindings/activejob_screen_binding.dart';
import '../modules/Activejob_screen/views/activejob_screen_view.dart';
import '../modules/AddressScreen/bindings/address_screen_binding.dart';
import '../modules/AddressScreen/views/address_screen_view.dart';
import '../modules/BookingConfirm/bindings/booking_confirm_binding.dart';
import '../modules/BookingConfirm/views/booking_confirm_view.dart';
import '../modules/BricklayingHelper/bindings/bricklaying_helper_binding.dart';
import '../modules/BricklayingHelper/views/bricklaying_helper_view.dart';
import '../modules/CementHelper/bindings/cement_helper_binding.dart';
import '../modules/CementHelper/views/cement_helper_view.dart';
import '../modules/Scaffolding_helper/bindings/scaffolding_helper_binding.dart';
import '../modules/Scaffolding_helper/views/scaffolding_helper_view.dart';
import '../modules/ServiceCompleted/bindings/service_completed_binding.dart';
import '../modules/ServiceCompleted/views/service_completed_view.dart';
import '../modules/ServiceCompletedSuccessfully/bindings/service_completed_successfully_binding.dart';
import '../modules/ServiceCompletedSuccessfully/views/service_completed_successfully_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/add_address/bindings/add_address_binding.dart';
import '../modules/add_address/views/add_address_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/bottom/bindings/bottom_binding.dart';
import '../modules/bottom/views/bottom_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat_screen/bindings/chat_screen_binding.dart';
import '../modules/chat_screen/views/chat_screen_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/helper_profile/bindings/helper_profile_binding.dart';
import '../modules/helper_profile/views/helper_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/join/bindings/join_binding.dart';
import '../modules/join/views/join_view.dart';
import '../modules/location/bindings/location_binding.dart';
import '../modules/location/views/location_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/plastering_helper/bindings/plastering_helper_binding.dart';
import '../modules/plastering_helper/views/plastering_helper_view.dart';
import '../modules/professional_plumber/bindings/professional_plumber_binding.dart';
import '../modules/professional_plumber/views/professional_plumber_view.dart';
import '../modules/professional_profile/bindings/professional_profile_binding.dart';
import '../modules/professional_profile/views/professional_profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/provider_home/bindings/provider_home_binding.dart';
import '../modules/provider_home/views/provider_home_view.dart';
import '../modules/provider_location/bindings/provider_location_binding.dart';
import '../modules/provider_location/views/provider_location_view.dart';
import '../modules/provider_login/bindings/provider_login_binding.dart';
import '../modules/provider_login/views/provider_login_view.dart';
import '../modules/provider_otp/bindings/provider_otp_binding.dart';
import '../modules/provider_otp/views/provider_otp_view.dart';
import '../modules/provider_profile/bindings/provider_profile_binding.dart';
import '../modules/provider_profile/views/provider_profile_view.dart';
import '../modules/road_construction_helper/bindings/road_construction_helper_binding.dart';
import '../modules/road_construction_helper/views/road_construction_helper_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/signUp/bindings/sign_up_binding.dart';
import '../modules/signUp/views/sign_up_view.dart';
import '../modules/splash1/bindings/splash1_binding.dart';
import '../modules/splash1/views/splash1_view.dart';
import '../modules/splash2/bindings/splash2_binding.dart';
import '../modules/splash2/views/splash2_view.dart';
import '../modules/splash3/bindings/splash3_binding.dart';
import '../modules/splash3/views/splash3_view.dart';
import '../modules/tile_fixing_helper/bindings/tile_fixing_helper_binding.dart';
import '../modules/tile_fixing_helper/views/tile_fixing_helper_view.dart';
import '../modules/worknest/bindings/worknest_binding.dart';
import '../modules/worknest/views/worknest_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM,
      page: () => const BottomView(),
      binding: BottomBinding(),
    ),
    GetPage(
      name: _Paths.WORKNEST,
      page: () => const WorknestView(),
      binding: WorknestBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH1,
      page: () => const Splash1View(),
      binding: Splash1Binding(),
    ),
    GetPage(
      name: _Paths.SPLASH2,
      page: () => const Splash2View(),
      binding: Splash2Binding(),
    ),
    GetPage(
      name: _Paths.SPLASH3,
      page: () => const Splash3View(),
      binding: Splash3Binding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.JOIN,
      page: () => const JoinView(),
      binding: JoinBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION,
      page: () => const LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TILE_FIXING_HELPER,
      page: () => const TileFixingHelperView(),
      binding: TileFixingHelperBinding(),
    ),
    GetPage(
      name: _Paths.CEMENT_HELPER,
      page: () => CementHelperView(),
      binding: CementHelperBinding(),
    ),
    GetPage(
      name: _Paths.PLASTERING_HELPER,
      page: () => const PlasteringHelperView(),
      binding: PlasteringHelperBinding(),
    ),
    GetPage(
      name: _Paths.BRICKLAYING_HELPER,
      page: () => const BricklayingHelperView(),
      binding: BricklayingHelperBinding(),
    ),
    GetPage(
      name: _Paths.SCAFFOLDING_HELPER,
      page: () => const ScaffoldingHelperView(),
      binding: ScaffoldingHelperBinding(),
    ),
    GetPage(
      name: _Paths.ROAD_CONSTRUCTION_HELPER,
      page: () => const RoadConstructionHelperView(),
      binding: RoadConstructionHelperBinding(),
    ),
    GetPage(
      name: _Paths.PROFESSIONAL_PLUMBER,
      page: () => const ProfessionalPlumberView(),
      binding: ProfessionalPlumberBinding(),
    ),
    GetPage(
      name: _Paths.PROFESSIONAL_PROFILE,
      page: () => const ProfessionalProfileView(),
      binding: ProfessionalProfileBinding(),
    ),
    GetPage(
      name: _Paths.HELPER_PROFILE,
      page: () => const HelperProfileView(),
      binding: HelperProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.ADD_ADDRESS,
      page: () => const AddAddressView(),
      binding: AddAddressBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_CONFIRM,
      page: () => const BookingConfirmView(),
      binding: BookingConfirmBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_COMPLETED,
      page: () => const ServiceCompletedView(),
      binding: ServiceCompletedBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_COMPLETED_SUCCESSFULLY,
      page: () => const ServiceCompletedSuccessfullyView(),
      binding: ServiceCompletedSuccessfullyBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_SCREEN,
      page: () => AddressScreenView(),
      binding: AddressScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_LOGIN,
      page: () => const ProviderLoginView(),
      binding: ProviderLoginBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_OTP,
      page: () => const ProviderOtpView(),
      binding: ProviderOtpBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_LOCATION,
      page: () => const ProviderLocationView(),
      binding: ProviderLocationBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_PROFILE,
      page: () => const ProviderProfileView(),
      binding: ProviderProfileBinding(),
    ),
    GetPage(
      name: _Paths.PROVIDER_HOME,
      page: () => const ProviderHomeView(),
      binding: ProviderHomeBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVEJOB_SCREEN,
      page: () => const ActivejobScreenView(),
      binding: ActivejobScreenBinding(),
    ),
  ];
}
