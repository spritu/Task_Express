import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../controllers/provider_chat_screen_controller.dart';

class ProviderChatScreenView extends GetView<ProviderChatScreenController> {
  const ProviderChatScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appGradient2,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          InkWell(onTap:(){
                            Get.back();
                          },
                              child: Icon(Icons.arrow_back)),
                          const SizedBox(width: 20),
                          const Text(
                            'Chat with user',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.call, color: Colors.black),
                            onPressed: () {
                              // Call logic
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Obx(
                            () => Chat(
                          messages: controller.messages.toList(),
                          onSendPressed: controller.handleSendPressed,
                          user: controller.user,
                          showUserAvatars: true,
                          showUserNames: true,
                          onAttachmentPressed: controller.handleImagePick,
                          avatarBuilder: (user) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey.shade400,
                              child: const Icon(Icons.person, color: Colors.white),
                            );
                          },
                          theme: const DefaultChatTheme(
                            inputBackgroundColor: Colors.white,
                            inputTextColor: Colors.black,
                            inputTextStyle: TextStyle(fontFamily: 'Poppins'),
                            backgroundColor: Colors.transparent, // 👈 let gradient show
                            primaryColor: Color(0xFF114BCA),
                            secondaryColor: Colors.white,
                            messageBorderRadius: 16,
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    //   child: Container(width: MediaQuery.of(context).size.width*0.7,
                    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xFFDCE6FF),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         const Expanded(
                    //           child: Text(
                    //             'Are you satisfied with this conversation?',
                    //             style: TextStyle(
                    //               fontSize: 10,
                    //               fontFamily: 'Poppins',
                    //               fontWeight: FontWeight.w500,
                    //               color: Colors.black87,
                    //             ),
                    //           ),
                    //         ),
                    //         ElevatedButton(
                    //           onPressed: () {
                    //             // Book Now logic
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: AppColors.blue,
                    //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //           ),
                    //           child: const Text(
                    //             'Book Now',
                    //             style: TextStyle(fontSize: 10,
                    //               fontFamily: 'Poppins',color: AppColors.white,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
