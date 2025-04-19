import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/Activejob_screen/controllers/activejob_screen_controller.dart';
import 'app/modules/Bottom2/controllers/bottom2_controller.dart';
import 'app/modules/BricklayingHelper/controllers/bricklaying_helper_controller.dart';
import 'app/modules/Scaffolding_helper/controllers/scaffolding_helper_controller.dart';
import 'app/modules/bottom/controllers/bottom_controller.dart';
import 'app/modules/chat/controllers/chat_controller.dart';
import 'app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/modules/jobs/controllers/jobs_controller.dart';
import 'app/modules/jobsDetails/controllers/jobs_details_controller.dart';
import 'app/modules/join/views/join_view.dart';
import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/otp/controllers/otp_controller.dart';
import 'app/modules/plastering_helper/controllers/plastering_helper_controller.dart';
import 'app/modules/professional_plumber/controllers/professional_plumber_controller.dart';
import 'app/modules/provider_ChatScreen/controllers/provider_chat_screen_controller.dart';
import 'app/modules/provider_account/controllers/provider_account_controller.dart';
import 'app/modules/provider_chat/controllers/provider_chat_controller.dart';
import 'app/modules/provider_editProfile/controllers/provider_edit_profile_controller.dart';
import 'app/modules/provider_home/controllers/provider_home_controller.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LoginController());
  Get.put(WorknestController());
  Get.put(SignUpController());
  Get.put(BottomController());
  Get.put(HomeController());
  Get.put(PlasteringHelperController());
  Get.put(BricklayingHelperController());
  Get.put(ScaffoldingHelperController());
  Get.put(TileFixingHelperController());Get.put(JobsDetailsController());
  Get.put(RoadConstructionHelperController());
  Get.put(ProfessionalPlumberController());
  Get.put(SettingController());
  Get.put(EditProfileController());Get.put(JobsController());
  Get.put(ChatController());Get.put(ProviderSettingController());Get.put(ProviderChatController());
  Get.put(OtpController());Get.put(ProviderHomeController());Get.put(ProviderEditProfileController());
  Get.put(ProviderLoginController());Get.put(ActivejobScreenController());Get.put(ProviderChatScreenController());
  Get.put(ProviderOtpController());Get.put(Bottom2Controller());Get.put(ProviderAccountController());
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

    // Automatically jump from Splash1 to Splash2 after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (_controller.hasClients && _currentPage == 0) {
        _controller.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: const [
              Splash1View(),
              Splash2View(),
              Splash3View(),
            ],
          ),
          // Show nav buttons only on Splash2 & Splash3
          if (_currentPage != 0)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Color(0xff090F47),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      2,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: (_currentPage == 1 && index == 0) || (_currentPage == 2 && index == 1)
                              ? const Color(0xff235CD7)
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
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Get.to(() => JoinView());
                      }
                    },
                    child: Text(
                      _currentPage == 2 ? "Next" : "Next",
                      style: const TextStyle(
                        color: Color(0xff090F47),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
