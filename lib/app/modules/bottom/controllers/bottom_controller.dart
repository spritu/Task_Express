import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../auth_controller.dart';
import '../../login/views/login_view.dart'; // Ensure this path is correct
class BottomController extends GetxController {
  final count = 0.obs;
  var selectedIndex = 0.obs;
  var bookingData = {}.obs;
  var showRequestPending = false.obs;
  var helperName = ''.obs;
  var selected = 0.obs;

  final AuthController authController = Get.find<AuthController>();

  void cancelRequest() {
    showRequestPending.value = false;
    helperName.value = '';
  }

  void checkAndShowSignupSheet(BuildContext context) {
    if (!authController.isLoggedIn.value) {
      showSignupSheet(context);
    }
  }

  void showSignupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffD9E4FC),
              boxShadow: [BoxShadow(blurRadius: 4, color: Color(0xFFD9E4FC))],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        Row(
                          children: const [
                            Text(
                              "Sign Up Required ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Icon(Icons.arrow_downward),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Image
                    Image.asset(
                      "assets/images/Signupbro.png",
                      height: 293,
                      width: 393,
                    ),
                    const SizedBox(height: 20),

                    /// Info Text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Please verify your mobile number to continue \nusing TaskExpress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Continue Button
                    SizedBox(
                      height: 36.93,
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF114BCA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Get.back(); // Close bottom sheet
                          Get.to(() => LoginView()); // Go to login
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Note Text
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'This helps us personalize your experience and keep your data secure.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
