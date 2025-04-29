import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../controllers/user_help_controller.dart';

class UserHelpView extends GetView<UserHelpController> {
  const UserHelpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: (){
                        Get.back();
                      },
                          child: Icon(Icons.arrow_back)),
                      Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(" "),
                    ],
                  ),
                  SizedBox(height: 40),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          buildList(
                            context,
                            "Service provider didn’t show up",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Service was incomplete",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Quality of service was poor",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Extra charge asked",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,

                            "Rude or unsafe behavior",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,

                            "i want to reschedule my job",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,

                            "Payment or billing issue",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,

                            "I want to cancel my booking",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,

                            "Need help with using the app",
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9E4FC), // Light peach background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Need assistance?",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Service Guidelines Button
                            SizedBox(
                              height: 40,
                              width: 130,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Navigate to Service Guidelines
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF114BCA),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  foregroundColor: Colors.black,
                                ),
                                icon: const Icon(
                                  Icons.menu_book_rounded,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  "Service\nGuidelines",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),


                            Container(
                              height: 40,
                              width: 130,

                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Make a support call
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF114BCA),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  foregroundColor: Colors.black,
                                ),
                                icon: const Icon(
                                  Icons.phone_in_talk_rounded,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  "Partner\nSupport Call",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(
      BuildContext context,
      String name,
      IconData trailingIcon, {
        TextSpan? richText,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child:
            richText != null
                ? RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: "Poppins",
                  color: Colors.black,
                ),
                children: [TextSpan(text: name), richText],
              ),
            )
                : Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Icon(trailingIcon, size: 16, color: Colors.black54),
        ],
      ),
    );
  }
}