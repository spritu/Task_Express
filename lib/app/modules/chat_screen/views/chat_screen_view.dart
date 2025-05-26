import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../chat/views/chat_view.dart';
import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  const ChatScreenView({super.key});



  @override
  Widget build(BuildContext context) {
  Get.put(ChatScreenController());
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: AppColors.appGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),

                  // Header
                  const Text(
                    " Chats",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: "poppins",
                    ),
                  ),
                  const Text("         "),
                  const SizedBox(height: 10),
                  const CustomSearchBar(),
                  const SizedBox(height: 20),

                  // Chat List
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: controller.chats.length,
                        itemBuilder: (context, index) {
                          final chat = controller.chats[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  ChatView(),
                                  arguments: {
                                    'receiverId': chat.reciverId,
                                    'receiverName':
                                    '${chat.firstName} ${chat.lastName}',
                                    'receiverImage': chat.profilePic,
                                  },
                                )?.then((_) async {
                                  await controller.fetchLastMessages();
                                });
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // Profile Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          child:
                                          chat.profilePic.isNotEmpty
                                              ? Image.network(
                                            chat.profilePic,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                context,
                                                error,
                                                stack,
                                                ) => Image.asset(
                                              "assets/images/account.png",
                                              width: 50,
                                              height: 50,
                                            ),
                                          )
                                              : Image.asset(
                                            "assets/images/account.png",
                                            width: 50,
                                            height: 50,
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
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${chat.firstName} ${chat.lastName}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontFamily: "poppins",
                                                      fontSize: 12,
                                                    ),
                                                  ),

                                                  Text(
                                                    controller.formatTimestamp(
                                                      chat.timestamp,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontFamily: "poppins",
                                                      color: Color(0xFF545454),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),

                                              // Message Preview
                                              Text(
                                                chat.message,
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
                      );
                    }),
                  ),
                ],
              ),
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