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
        Get.find<BottomController>().selectedIndex.value = 0;
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
                              onTap: () async {
                                final bottomController = Get.put(
                                  BottomController(),
                                );
                                bottomController.markChatNotificationAsSeen();

                                await controller.markChatAsRead(chat.reciverId);

                                Get.to(
                                  ChatView(),
                                  arguments: {

                                    'receiverId': chat.reciverId,
                                    'receiverName':
                                        '${chat.firstName} ${chat.lastName}',
                                    'receiverImage': chat.profilePic,
                                    'catId': chat.catId,
                                    'subCatId': chat.subCatId,
                                    'charge': chat.charge,
                                    'phone': chat.phone,
                                  },
                                )?.then((_) async {
                                  await controller.markChatAsRead(
                                    chat.reciverId,
                                  );
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
                                                  BorderRadius.circular(
                                                    25,
                                                  ), // round profile pic
                                              child: Image.network(
                                                //  If chat.profilePic is not empty, use full URL
                                                chat.profilePic.isNotEmpty
                                                    ? (chat.profilePic
                                                            .startsWith('http')
                                                        ? chat.profilePic
                                                        : 'https://jdapi.youthadda.co/${chat.profilePic}')
                                                    : 'https://jdapi.youthadda.co/invalid.jpg', // dummy fallback to trigger errorBuilder

                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,

                                                // If image fails to load, show default asset
                                                errorBuilder: (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) {
                                                  return Image.asset(
                                                    "assets/images/account.png",
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
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
          Icon(Icons.search, color: Color(0xFF5F5D5D), size: 24),
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
