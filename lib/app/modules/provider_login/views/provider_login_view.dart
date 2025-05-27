import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../auth_controller.dart';
import '../../../../colors.dart';
import '../../provider_otp/views/provider_otp_view.dart';
import '../controllers/provider_login_controller.dart';

class ProviderLoginView extends GetView<ProviderLoginController> {
  const ProviderLoginView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProviderLoginController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(decoration: BoxDecoration( gradient: AppColors.appGradient2 ),
          //  margin: EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SizedBox(height: MediaQuery.of(context).size.height*0.2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Task',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xff114BCA),
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          height: 0.476, // equivalent to 20px line-height
                          letterSpacing: 2.1, // 5% of 42
                        ),
                      ),
                      TextSpan(
                        text: 'Express',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xffF67C0A),
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          height: 0.476,
                          letterSpacing: 2.1,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 14),
                Text(
                  'Find Trusted Service Providers\n Instantly!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.857, // line-height equivalent
                    letterSpacing: 1.54, // 11% of 14px
                    color: Color(0xff2D2D2D),
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/beg.png", height: 19, width: 20),
                    SizedBox(width: 5),
                    Text('Find work',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff746E6E),
                            fontWeight: FontWeight.w400)),
                    SizedBox(width: 10),
                    Container(height: 16, width: 1, color: Color(0xff746E6E)),
                    SizedBox(width: 10),
                    Image.asset("assets/images/hired.png",
                        height: 19, width: 20),
                    SizedBox(width: 5),
                    Text('Get Hired',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff746E6E),
                            fontWeight: FontWeight.w400)),
                    SizedBox(width: 10),
                    Container(height: 16, width: 1, color: Color(0xff746E6E)),
                    SizedBox(width: 10),
                    Image.asset("assets/images/grow.png", height: 19, width: 20),
                    SizedBox(width: 5),
                    Text('Grow',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff746E6E),
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                TextField(
                  controller: controller.mobileeController,
                  keyboardType: TextInputType.phone,
                  //  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Text(
                        "+91",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded border
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                  ),
                ),SizedBox(height: 20),
                InkWell(onTap: (){controller.sendOtp();
                final AuthController authController = Get.find();
                },
                  child: Container(
                    height: 64,
                    width: MediaQuery.of(context).size.width*0.6,
                    decoration: BoxDecoration(
                      color: AppColors.orage,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Get Verification Code",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(text: 'By continuing, you agree to our'),
                      TextSpan(
                        text: '\nTerms & Conditions',
                        style: TextStyle(
                          color: AppColors.orage,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                        TapGestureRecognizer()..onTap = controller.openTerms,
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color:AppColors.orage,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                        TapGestureRecognizer()..onTap = controller.openPrivacy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}