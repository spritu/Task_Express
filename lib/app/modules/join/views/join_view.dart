import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../login/views/login_view.dart';
import '../../provider_login/views/provider_login_view.dart';
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
            end: Alignment.center,
            colors: [
              Color(0xFF87AAF6),
              Colors.white,
            ],
          ),),
          //margin: EdgeInsets.only(left: 16, right: 16),
          // alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    // Top info text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Find & book services easily",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // User Button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Color(0xFF0047FF),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextButton.icon(
                        onPressed: () => Get.to(LoginView()),
                        icon: Icon(Icons.person, color: Colors.white, size: 20),
                        label: Text(
                          "Join as a User",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Bottom info text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Offer your skills & start earning",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Provider Button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Color(0xffF67C0A),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextButton.icon(
                        onPressed: () => Get.to(ProviderLoginView()),
                        icon: Image.asset(
                          "assets/images/service_provider.png",
                          height: 20,
                          width: 20,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Join as a Provider",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
