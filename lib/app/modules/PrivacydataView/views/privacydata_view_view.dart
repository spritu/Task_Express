import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../colors.dart';

import '../controllers/privacydata_view_controller.dart';

class PrivacydataViewView extends GetView<PrivacydataViewController> {
  const PrivacydataViewView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PrivacydataViewController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
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
                          "Privacy & Data",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balances the back button space
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      Text(
                        "1. What We Collect",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "• Personal Info: Name, Phone Number, Email",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Location Access: To assign nearby tasks & professionals",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Payment Info: Secured third-party gateways only",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Usage Data: App interactions & preferences (for better personalization)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "2. Why We Collect It",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "• To match you with the right service provider",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• To ensure secure login & profile management",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• To improve app features and user experience",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• To send updates, promotions & relevant offers",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "3. How We Protect Your Data",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "• End-to-End Encryption",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Regular Security Audits",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• No unauthorized data sharing",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Role-based data access (User/Service Provider/Admin)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "4. You Control Your Data",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "• Edit your profile anytime",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Request data deletion",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• Opt-in/opt-out of communications",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "• View or update permissions in app settings",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "Third-Party Services",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "We integrate with trusted partners (e.g., payment gateways, map services) — each complying with standard data privacy protocols.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "Have Questions?",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "Email us at: support@taskexpress.in",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "Or visit the Help & Support section in the app.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),

                      SizedBox(height: 16),
                      Text(
                        "Thank You",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "We’re committed to creating a safe and transparent experience for everyone. Thank you for trusting Task Express.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(height: 32),
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