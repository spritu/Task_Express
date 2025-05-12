import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../colors.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 20),
                    Obx(() => Text(
                      'Chat with ${controller.receiverName.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    const Spacer(),
                    Row(
                      children: [
                        Image.asset("assets/images/i.png", height: 24),
                        const SizedBox(width: 9),
                        Image.asset("assets/images/person.png", height: 24),
                        const SizedBox(width: 9),
                        const Icon(Icons.call, color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (!controller.isReady.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Chat(
                    messages: controller.messages.toList(),
                    onSendPressed: controller.handleSendPressed,
                    user: controller.currentUser,
                    onAttachmentPressed: controller.handleImagePick,
                    showUserAvatars: true,
                    showUserNames: true,
                    avatarBuilder: (user) {
                      if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
                        return CircleAvatar(
                          radius: 16,
                          backgroundImage: FileImage(File(user.imageUrl!)),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade400,
                          child: Text(
                            user.firstName?.isNotEmpty == true
                                ? user.firstName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    },
                    theme: const DefaultChatTheme(
                      inputBackgroundColor: Colors.white,
                      inputTextColor: Colors.black,
                      inputTextStyle: TextStyle(fontFamily: 'Poppins'),
                      backgroundColor: Colors.transparent,
                      primaryColor: Color(0xFF114BCA),
                      secondaryColor: Colors.white,
                      messageBorderRadius: 16,
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Are you satisfied with this conversation?',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Add booking logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
