import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:worknest/colors.dart';

import '../controllers/join_controller.dart';

class JoinView extends GetView<JoinController> {
  const JoinView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration( gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87AAF6),
              Colors.white,
            ],
          ),),
          //margin: EdgeInsets.only(left: 16, right: 16),
          // alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SizedBox(
                     height: MediaQuery.of(context).size.height*0.1),
                  Image.asset("assets/images/icon.png"),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Task',
                          style: TextStyle(
                              color: Color(0xff114BCA),
                              fontSize: 42,
                              fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: 'Express',
                          style: TextStyle(
                              color: Color(0xffF67C0A),
                              fontSize: 42,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Find Trusted Service Providers\n Instantly!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.0,
                      height: 1.2,
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
                  SizedBox(height: 40),
                  SizedBox(width: MediaQuery.of(context).size.width*0.7,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Find & book services easily",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),SizedBox(height: 5),
                  Container(
                    height: 54,width: MediaQuery.of(context).size.width*0.7,
                    decoration: BoxDecoration(
                      color: Color(0xFF0047FF), // Deep blue
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.person,size: 24,
                        color: Colors.white,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Join as a User",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(width: MediaQuery.of(context).size.width*0.7,
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Offer your skills & start earning",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),SizedBox(height: 5),
                  Container(
                    height: 54,width: MediaQuery.of(context).size.width*0.7,
                    decoration: BoxDecoration(
                      color: Color(0xffF67C0A), // Deep blue
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon:

                      Image.asset("assets/images/service_provider.png",height: 24,width: 24,color: Colors.white,),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Join as a Provider",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Obx(
                  //       () => Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Checkbox(
                  //         value: controller.isChecked.value,
                  //         onChanged: (value) {
                  //           controller.isChecked.value = value!;
                  //         },
                  //         activeColor: Color(0xff235CD7),
                  //         checkColor: Colors.white,
                  //       ),
                  //       Text(
                  //         "Get order updates on WhatsApp",
                  //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     style: TextStyle(color: Colors.black, fontSize: 14),
                  //     children: [
                  //       TextSpan(text: 'By continuing, you agree to our'),
                  //       TextSpan(
                  //         text: '\nTerms & Conditions',
                  //         style: TextStyle(
                  //           color: Color(0xff235CD7),
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         recognizer:
                  //         TapGestureRecognizer()..onTap = controller.openTerms,
                  //       ),
                  //       TextSpan(text: ' and '),
                  //       TextSpan(
                  //         text: 'Privacy Policy',
                  //         style: TextStyle(
                  //           color: Color(0xff235CD7),
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         recognizer:
                  //         TapGestureRecognizer()..onTap = controller.openPrivacy,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
