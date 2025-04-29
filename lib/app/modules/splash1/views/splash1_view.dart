import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../controllers/splash1_controller.dart';

class Splash1View extends GetView<Splash1Controller> {
  const Splash1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(decoration: BoxDecoration( gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Color(0xFF87AAF6),
          Colors.white,
        ],
      ), ),
        child: Center( // This will center everything vertically
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // shrink column to content size
              children: [
                Image.asset("assets/images/icon.png"),
              //  SizedBox(height: 10),
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

                SizedBox(height: 19),
                Center(
                  child: Text(
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
                ),

                SizedBox(height: 15),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}