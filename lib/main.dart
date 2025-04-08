import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/bottom/controllers/bottom_controller.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/login/views/login_view.dart';
import 'app/modules/signUp/controllers/sign_up_controller.dart';
import 'app/modules/splash1/views/splash1_view.dart';
import 'app/modules/splash2/views/splash2_view.dart';
import 'app/modules/splash3/views/splash3_view.dart';
import 'app/modules/worknest/controllers/worknest_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LoginController());
  Get.put(WorknestController());
  Get.put(SignUpController());
  Get.put(BottomController());Get.put(HomeController());
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
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
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

                // Page Indicators
                Row(
                  children: List.generate(
                    3,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xff235CD7)
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // Next / Done Button
                TextButton(
                  onPressed: () {
                    if (_currentPage < 2) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      // Go to login or home screen after last page
                      Get.to(() => LoginView());
                    }
                  },
                  child: Text(
                    _currentPage == 2 ? "Done" : "Next",
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