import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:get/get.dart';
import 'package:worknest/app/modules/provider_chat/views/provider_chat_view.dart';

import '../../../../colors.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../controllers/provider_chat_screen_controller.dart';

class ProviderChatScreenView extends GetView<ProviderChatScreenController> {
  const ProviderChatScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProviderChatScreenController());
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.appGradient2),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Chats",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: "poppins",
                    ),
                  ),
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
                              onTap: () async {
                                final bottom2controller = Get.put(
                                  Bottom2Controller(),
                                );
                                await bottom2controller
                                    .markChatNotificationAsSeen();
                                await controller.markChatAsRead(chat.reciverId);

                                // await controller.fetchAllMessages();
                                Get.to(
                                  ProviderChatView(),
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
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Delete Chat'),
                                        content: const Text(
                                          'Are you sure you want to delete this chat?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              // await controller.deleteChat(chat.reciverId);
                                              // await controller.fetchLastMessages();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
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
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
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
                                            // if (chat.unreadCount > 0)
                                            //   Positioned(
                                            //     right: 0,
                                            //     top: 0,
                                            //     child: Container(
                                            //       padding: const EdgeInsets.all(
                                            //         4,
                                            //       ),
                                            //       decoration: BoxDecoration(
                                            //         color: Colors.red,
                                            //         shape: BoxShape.circle,
                                            //       ),
                                            //       constraints:
                                            //           const BoxConstraints(
                                            //             minWidth: 20,
                                            //             minHeight: 20,
                                            //           ),
                                            //       child: Center(
                                            //         child: Text(
                                            //           '${chat.unreadCount}',
                                            //           style: const TextStyle(
                                            //             color: Colors.white,
                                            //             fontSize: 10,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),

                                        // Chat Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${chat.firstName} ${chat.lastName}',
                                                    style: const TextStyle(
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    chat.message,
                                                    style: TextStyle(
                                                      fontFamily: "poppins",
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (chat.unreadCount > 0)
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            left: 8,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.green,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      constraints:
                                                          const BoxConstraints(
                                                            minWidth: 20,
                                                            minHeight: 20,
                                                          ),
                                                      child: Center(
                                                        child: Text(
                                                          '${chat.unreadCount}',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
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
