import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';

import '../../otp/views/otp_view.dart';
import '../.../../.././profile/views/profile_view.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAllNamed('/home'); // Navigate to Home or Dashboard
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Text("skip", style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
              //  SizedBox(height: 40),
              // App Name
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Task',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Express',
                      style: TextStyle(
                        color: Color(0xff235CD7),
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              // Tagline
              Text(
                "Find Trusted Service Providers\n Instantly!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff3F3F3F),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Full Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontFamily: "poppins",
                    ),
                  ),
                ],
              ),
               TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                //  labelText: "Full Name",
                  hintText: "Enter full name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Add rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // Default border when not focused
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // Border when focused
                    borderSide: BorderSide(color: Color(0xff235CD7), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Phone Number Field
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontFamily: "poppins",
                    ),
                  ),
                ],
              ),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                //  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Add rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // Default border when not focused
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // Border when focused
                    borderSide: BorderSide(color: Color(0xff235CD7), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // Email Field
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontFamily: "poppins",
                    ),
                  ),
                ],
              ),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                 // labelText: "Email",
                  hintText: "Enter email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Add rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // Default border when not focused
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    // Border when focused
                    borderSide: BorderSide(color: Color(0xff235CD7), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontFamily: "poppins",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              // Gender Selection
              Obx(
                () => Row(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GenderButton(controller, "Female"),
                    SizedBox(width: 15),
                    GenderButton(controller, "Male"),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              // Proceed Button
              InkWell(
                onTap: () {
                 Get.to(ProfileView());
                },
                child: Container(
                  // width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xff235CD7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Proceed",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Service Provider Sign-up Link
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  children: [
                    // TextSpan(text: "Click "),
                    TextSpan(
                      text: "Click here",
                      style: TextStyle(
                        color: Color(0xff235CD7),
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              print("Navigate to Service Provider Sign-up");
                            },
                    ),
                    TextSpan(text: " for Service provider sign-up"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gender Button Widget
Widget GenderButton(SignUpController controller, String gender) {
  return InkWell(
    onTap: () {
      controller.selectedGender.value = gender;
    },
    child: Container(
      width: 100,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color:
            controller.selectedGender.value == gender
                ? Color(0xff235CD7)
                : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          gender,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color:
                controller.selectedGender.value == gender
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    ),
  );
}
