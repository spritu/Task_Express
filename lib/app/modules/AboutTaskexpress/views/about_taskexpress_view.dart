import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../colors.dart';
import '../controllers/about_taskexpress_controller.dart';

class AboutTaskexpressView extends GetView<AboutTaskexpressController> {
  const AboutTaskexpressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "About TaskExpress",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // To balance the back icon space
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Task Express is your go-to mobile application for booking trusted home services—quickly, safely, and effortlessly. Whether it’s plumbing, electrical repair, home cleaning, or appliance servicing, Task Express connects you with skilled professionals at the tap of a button.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "We believe in making life easier. That’s why we’re building a platform where reliability meets convenience. With real-time tracking, secure payments, and verified service providers, Task Express ensures you get quality service on time, every time.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Our platform empowers both customers and service providers—offering users an easy way to get tasks done, while giving professionals the tools and visibility to grow their business.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "We’re truly grateful to have you as part of the Task Express community. Your trust drives us to deliver better every day. Whether you’re here to get things done or to grow your service, we’re with you—every step of the way.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: "– Team "),
                            TextSpan(
                              text: "Task",
                              style: const TextStyle(color: Colors.blue),
                            ),
                            TextSpan(
                              text: "Express",
                              style: const TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
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