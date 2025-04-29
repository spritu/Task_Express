import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../join/views/join_view.dart';
import '../../splash1/views/splash1_view.dart';
import '../../splash2/views/splash2_view.dart';
import '../../splash3/views/splash3_view.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.page,
            onPageChanged: (index) {

                controller.currentPage = index;

            },
            children: const [
              Splash1View(),
              Splash2View(),
              Splash3View(),
            ],
          ),
          // Show nav buttons only on Splash2 & Splash3
          if (controller.currentPage != 0)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.page.jumpToPage(2);
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
                          color: (controller.currentPage == 1 && index == 0) || (controller.currentPage == 2 && index == 1)
                              ? const Color(0xff235CD7)
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.currentPage < 2) {
                        controller.page.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Get.to(() => JoinView());
                      }
                    },
                    child: Text(
                      controller.currentPage == 2 ? "Next" : "Next",
                      style:  TextStyle(
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
