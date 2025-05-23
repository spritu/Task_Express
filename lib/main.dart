import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // <-- ADD THIS
import 'package:shared_preferences/shared_preferences.dart';

// All your imports
import 'app/modules/Activejob_screen/controllers/activejob_screen_controller.dart';
import 'app/modules/Bottom2/controllers/bottom2_controller.dart';
import 'app/modules/BricklayingHelper/controllers/bricklaying_helper_controller.dart';
import 'app/modules/CancelBooking/controllers/cancel_booking_controller.dart';
import 'app/modules/Scaffolding_helper/controllers/scaffolding_helper_controller.dart';
import 'app/modules/account/controllers/account_controller.dart';
import 'app/modules/add_address/controllers/add_address_controller.dart';
import 'app/modules/booking/controllers/booking_controller.dart';
import 'app/modules/bottom/controllers/bottom_controller.dart';
import 'app/modules/bottom/views/bottom_view.dart';
import 'app/modules/chat/controllers/chat_controller.dart';
import 'app/modules/chat_screen/controllers/chat_screen_controller.dart';
import 'app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/modules/jobs/controllers/jobs_controller.dart';
import 'app/modules/jobsDetails/controllers/jobs_details_controller.dart';
import 'app/modules/join/views/join_view.dart';
import 'app/modules/location/controllers/location_controller.dart';
import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/otp/controllers/otp_controller.dart';
import 'app/modules/plastering_helper/controllers/plastering_helper_controller.dart';
import 'app/modules/professional_plumber/controllers/professional_plumber_controller.dart';
import 'app/modules/professional_profile/controllers/professional_profile_controller.dart';
import 'app/modules/provider_ChatScreen/controllers/provider_chat_screen_controller.dart';
import 'app/modules/provider_account/controllers/provider_account_controller.dart';
import 'app/modules/provider_chat/controllers/provider_chat_controller.dart';
import 'app/modules/provider_editProfile/controllers/provider_edit_profile_controller.dart';
import 'app/modules/provider_home/controllers/provider_home_controller.dart';
import 'app/modules/provider_location/controllers/provider_location_controller.dart';
import 'app/modules/provider_login/controllers/provider_login_controller.dart';
import 'app/modules/provider_otp/controllers/provider_otp_controller.dart';
import 'app/modules/provider_setting/controllers/provider_setting_controller.dart';
import 'app/modules/road_construction_helper/controllers/road_construction_helper_controller.dart';
import 'app/modules/setting/controllers/setting_controller.dart';
import 'app/modules/signUp/controllers/sign_up_controller.dart';
import 'app/modules/splash1/views/splash1_view.dart';
import 'app/modules/splash2/views/splash2_view.dart';
import 'app/modules/splash3/views/splash3_view.dart';
import 'app/modules/tile_fixing_helper/controllers/tile_fixing_helper_controller.dart';
import 'app/modules/worknest/controllers/worknest_controller.dart';
import 'app/routes/app_pages.dart';
import 'auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // SharedPreferences prefs = await SharedPreferences.getInstance();// <-- ADD THIS
  final box = GetStorage();
  // await prefs.clear();
  final isLoggedIn = box.read('isLoggedIn') ?? false;
  final isLoggedIn2 = box.read('isLoggedIn2') ?? false;


  //Get.put(WorknestController(),permanent: true);
  //Get.put(SignUpController(),permanent: true);
  //Get.put(BottomController(),permanent: true);
 // Get.put(HomeController(),permanent: true);
  //Get.put(CancelBookingController(),permanent: true);

  Get.put(PlasteringHelperController(),permanent: true);
  Get.put(BricklayingHelperController(),permanent: true);
  Get.put(BookingController(),permanent: true);
  Get.put(ScaffoldingHelperController(),permanent: true);

  Get.put(AuthController(),permanent: true);
  Get.put(TileFixingHelperController(),permanent: true);
  Get.put(JobsDetailsController(),permanent: true);
  Get.put(RoadConstructionHelperController(),permanent: true);
  Get.put(ProfessionalPlumberController(),permanent: true);
  Get.put(SettingController(),permanent: true);
  Get.put(EditProfileController(),permanent: true);
  Get.put(JobsController(),permanent: true);
  Get.lazyPut(() => ChatController(),fenix: true);
  Get.put(ProviderSettingController(),permanent: true);
  Get.lazyPut(()=>ProviderChatController(),fenix: true);
  Get.put(OtpController(),permanent: true);
 // Get.put(ProviderHomeController(),permanent: true);  //auto referesh
 // Get.put(ProviderEditProfileController(),permanent: true);
  Get.put(ProviderLoginController(),permanent: true);
  Get.put(ActivejobScreenController(),permanent: true);
  Get.put(ProviderChatScreenController(),permanent: true);
  Get.put(ProviderOtpController(),permanent: true);
  Get.put(Bottom2Controller(),permanent: true);
  Get.put(AddAddressController(),permanent: true);
  Get.put(ProfessionalProfileController(),permanent: true);
  Get.put(LocationController(),permanent: true);
  Get.put(ProviderLocationController(),permanent: true);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      getPages: AppPages.routes,
      home: SplashScreen(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // void checkLoginStatus() async {
  //   final box = GetStorage();
  //   final isLoggedIn = box.read('isLoggedIn') ?? false;
  //   final isLoggedIn2 = box.read('isLoggedIn2') ?? false;
  //
  //   print('isLoggedIn: $isLoggedIn');
  //   print('isLoggedIn2: $isLoggedIn2');
  //
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   print('userId: $userId');
  //
  //   await Future.delayed(Duration(seconds: 1));
  //
  //   if (isLoggedIn || userId != null) {
  //     Get.offAllNamed('/bottom');
  //   } else if (isLoggedIn2) {
  //     Get.offAllNamed('/bottom2');
  //   } else {
  //     startSplashFlow();
  //   }
  // }
  void checkLoginStatus() async {
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;
    final isLoggedIn2 = box.read('isLoggedIn2') ?? false;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    print('isLoggedIn: $isLoggedIn');
    print('isLoggedIn2: $isLoggedIn2');
    print('userId: $userId');

    await Future.delayed(Duration(seconds: 1));

    if (isLoggedIn2) {
      Get.offAllNamed('/bottom2'); // 👈 Pehle Login2 check karo
    } else if (isLoggedIn || userId != null) {
      Get.offAllNamed('/bottom');
    } else {
      startSplashFlow();
    }
  }



  void startSplashFlow() async {
    await Future.delayed(Duration(seconds: 2));
    if (_controller.hasClients) {
      _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    await Future.delayed(Duration(seconds: 2));
    if (_controller.hasClients) {
      _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (mounted && userId == null) {
      Get.offAll(() => JoinView()); // Show JoinView only if user never logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: const [
              Splash1View(),
              Splash2View(),
              Splash3View(),
            ],
          ),
          if (_currentPage != 0)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.offAll(() => JoinView());
                    },
                    child: Text("Skip", style: TextStyle(color: Color(0xff090F47), fontSize: 16)),
                  ),
                  Row(
                    children: List.generate(
                      2,
                          (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: (_currentPage == 1 && index == 0) ||
                              (_currentPage == 2 && index == 1)
                              ? Color(0xff235CD7)
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_currentPage < 2) {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                      } else {
                        Get.offAll(() => JoinView());
                      }
                    },
                    child: Text("Next", style: TextStyle(color: Color(0xff090F47), fontSize: 16)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}