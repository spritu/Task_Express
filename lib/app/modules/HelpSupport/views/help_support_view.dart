import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../controllers/help_support_controller.dart';

class HelpSupportView extends GetView<HelpSupportController> {
  const HelpSupportView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(HelpSupportController());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  SizedBox(height: 20),
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
                            "Job location is incorrect",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Customer was not available",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Customer behavior was inappropriate",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Materials not provided by customer",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Issue with payment received",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "App is not working properly",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "My account is blocked/suspended",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Report customer fraud/misuse",
                            Icons.arrow_forward_ios,
                          ),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            "Change registered phone or other detail",
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
                      color: const Color(0xFFFDE3CB), // Light peach background
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
                                    color: Color(0xFFF67C0A),
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

                          //  SizedBox(width: 50),
                            SizedBox(
                              child: SizedBox(
                                height: 40,
                                width: 130,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // TODO: Make a support call
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFFF67C0A),
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