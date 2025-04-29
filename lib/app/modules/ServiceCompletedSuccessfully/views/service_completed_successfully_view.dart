import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/service_completed_successfully_controller.dart';

class ServiceCompletedSuccessfullyView
    extends GetView<ServiceCompletedSuccessfullyController> {
  const ServiceCompletedSuccessfullyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end:Alignment.bottomCenter,
            stops: [0.1, 0.2],
            colors: [Color(0xFFC0D1F6), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Service Completed",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // spacing to balance the arrow
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 4),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Task",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            fontFamily: "poppins",
                            color: Color(0xFF114BCA),
                          ),
                        ),
                        Text(
                          " Express",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            fontFamily: "poppins",
                            color: Color(0xFFF67C0A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Find Trusted Service Providers\nInstantly!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 50),
                    const Text(
                      "“Thank You for Choosing Our Service”",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // Your "Book More" logic here
                      },
                      child: const Text(
                        "Book More",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "poppins",
                          fontSize: 14,
                          color: Color(0xFF114BCA),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dividerDot() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Text(
      "|",
      style: TextStyle(
        color: Color(0xFF746E6E),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget buildIconText(String image, String label) {
    return Row(
      children: [
        Image.asset(image, width: 20, height: 20, color: Color(0xFF746E6E)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "poppins",
            fontSize: 14,
            color: Color(0xFF746E6E),
          ),
        ),
      ],
    );
  }
}