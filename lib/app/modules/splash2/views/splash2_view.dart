import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../controllers/splash2_controller.dart';

class Splash2View extends GetView<Splash2Controller> {
  const Splash2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(decoration: BoxDecoration( gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            Color(0xFF87AAF6),
            Colors.white,
          ],
        )),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 120),
              Image.asset("assets/images/splash2.png",width: 344,
                  height: 321
              ),SizedBox(height: 20),
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
              SizedBox(height: 40),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Expert electricians at your service! Hassle-free\n'
                        'installations, efficient repairs, and a shock-proof\n'
                        'experience—anytime, anywhere!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}