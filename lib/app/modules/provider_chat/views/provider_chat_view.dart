import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../provider_ChatScreen/views/provider_chat_screen_view.dart';
import '../controllers/provider_chat_controller.dart';

class ProviderChatView extends GetView<ProviderChatController> {
  const ProviderChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [SizedBox(height: 20),
                // Header

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Icon(Icons.arrow_back),
                    const Text(
                      " Chats",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                    ),Icon(Icons.phone)
                  ],
                ),
           
                const SizedBox(height: 20),
                const CustomSearchBar(),
                const SizedBox(height: 20),

                // Chat List
                Expanded(
                  child: ListView.builder(
                    itemCount: 40,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(onTap: (){
                          Get.to(ProviderChatScreenView());
                        },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        "assets/images/professional_profile.png",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Chat Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // Name and Time
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Amit Sharma",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "poppins",
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "04:44 pm",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "poppins",
                                                  color: Color(0xFF545454),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),

                                          // Message Preview
                                          const Text(
                                            "Hello sir, aapka address samzha dejiye.",
                                            style: TextStyle(
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Divider
                              const Divider(
                                height: 1,
                                color: Colors.grey,
                                indent: 70,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Color(0xFF5F5D5D)),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}