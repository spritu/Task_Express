import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../HelpSupport/views/help_support_view.dart';
import '../../account/views/account_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../user_help/views/user_help_view.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final String defaultImg = 'assets/images/default_user.png';
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final BottomController navController = Get.find();

    Get.put(ChatController());
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xFFAEC6F9),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0, // 👈 This removes space between back icon and title
        title: Obx(
              () => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chat with ${controller.receiverName.value}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "poppins",
                ),
              ),

              Row(
                children: [InkWell(onTap: (){
                  Get.to(UserHelpView());
                },
                    child: Icon(Icons.info_outline)),SizedBox(width: 5,),
                  InkWell(onTap: (){
                   // navController.changeTab(3);
                  },
                      child: Icon(Icons.person)),SizedBox(width: 5,),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Get arguments passed from previous screen
                          final Map<String, dynamic> data = Get.arguments ?? {};
                          final phoneNumber = data['phoneNumber'] ?? '';

                          if (phoneNumber.isNotEmpty) {
                            controller.makePhoneCall(phoneNumber);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Phone number not available',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: Icon(Icons.call),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),


                ],
              ),

            ],
          ),
        ),
      ),


      body: Container(
        decoration: BoxDecoration(color: Color(0xFFAEC6F9)),
    child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages = controller.messages;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isSender = msg.author.id == controller.user.value?.id;
                    final name =
                    isSender ? "You" : controller.receiverName.value;
                    print('object121 ${controller.receiverImage.value}');
                    final imageUrl = (isSender
                        ? controller.user.value?.imageUrl
                        : controller.receiverImage.value)?.trim();

                    final ImageProvider displayImage = (imageUrl != null && imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/images/account.png');
                    final time =
                    msg.createdAt != null
                        ? TimeOfDay.fromDateTime(
                      DateTime.fromMillisecondsSinceEpoch(
                        msg.createdAt!,
                      ),
                    ).format(context)
                        : '';

                    if (msg is types.TextMessage) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: _buildMessageBubble(
                          isSender: isSender,
                          name: name,
                          message: msg.text,
                          time: time,
                          imageUrl: displayImage,
                        ),
                      );
                    } else if (msg is types.ImageMessage) {
                      return msg.uri.isNotEmpty
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: _buildImageMessageBubble(
                          isSender: isSender,
                          name: name,
                          imageFile: File(msg.uri),
                          time: time,
                          imageUrl: displayImage,
                        ),
                      )
                          : const SizedBox.shrink();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
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
                        // Book Now logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
            ),
            /// Message Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  // IconButton(
                  //   icon: const Icon(Icons.photo),
                  //   onPressed: controller.handleImagePick,
                  // ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final text = messageController.text.trim();
                      if (text.isNotEmpty) {
                        controller.handleSendPressed(
                          types.PartialText(text: text),
                        );
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),

            /// Book Now Section

          ],
        ),
      ),
    );
  }

  /// Bubble for text messages
  Widget _buildMessageBubble({
    required bool isSender,
    required String name,
    required String message,
    required String time,
    required ImageProvider imageUrl,
  }) {
    final alignment =
    isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
    final bubbleColor = isSender ? Color(0xFF114BCA) : Colors.white;
    final textColor = isSender ? Colors.white : Colors.black87;
    final radius =
    isSender
        ? BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
        if (!isSender) const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(message, style: TextStyle(color: textColor,fontSize: 12,fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 16,
                    color: isSender ? Colors.white : Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isSender) const SizedBox(width: 8),
        if (isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
      ],
    );
  }

  /// Bubble for image messages
  Widget _buildImageMessageBubble({
    required bool isSender,
    required String name,
    required File imageFile,
    required String time,
    required ImageProvider imageUrl,
  }) {
    final alignment =
    isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
    final radius =
    isSender
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
        if (!isSender) const SizedBox(width: 8),
        Column(
          crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSender ? Colors.blue[200] : Colors.grey[300],
                borderRadius: radius,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Image.file(
                  imageFile,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 16,
                  color: isSender ? Colors.blue : Colors.green,
                ),
              ],
            ),
          ],
        ),
        if (isSender) const SizedBox(width: 8),
        if (isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
      ],
    );
  }
}



// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:get/get.dart';
//
// import '../../../../colors.dart';
// import '../controllers/chat_controller.dart';
//
// class ChatView extends GetView<ChatController> {
//   final String defaultImg = 'assets/images/default_user.png';
//   const ChatView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController messageController = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(
//               () => Container(width: MediaQuery.of(context).size.width,
//                 child: Row(mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                 CircleAvatar(
//                   backgroundImage:
//                   controller.imagePath.value.isNotEmpty
//                       ? FileImage(File(controller.imagePath.value))
//                       : const AssetImage('assets/images/account.png'),
//                 ),
//                 const SizedBox(width: 5),
//                 Obx(() => Text(controller.receiverName.value)),
//                // Spacer(),
//                 IconButton(onPressed: () {}, icon: Icon(Icons.info_outline)),
//                 IconButton(onPressed: () {}, icon: Icon(Icons.person)),
//                 IconButton(onPressed: () {}, icon: Icon(Icons.call)),
//                             ],
//                           ),
//               ),
//         ),
//         backgroundColor: Color(0xFFAEC6F9),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(color: Color(0xFFAEC6F9)),
//         child: Column(
//           children: [
//             Expanded(
//               child: Obx(() {
//                 final messages = controller.messages;
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isSender = msg.author.id == controller.user.value?.id;
//                     final name =
//                     isSender ? "You" : controller.receiverName.value;
//                     print('object121 ${controller.receiverImage.value}');
//                     final imageUrl =
//                     (isSender
//                         ? controller.user.value?.imageUrl
//                         : controller.receiverImage.value)
//                         ?.trim();
//
//                     final ImageProvider displayImage =
//                     (imageUrl != null && imageUrl.isNotEmpty)
//                         ? NetworkImage(imageUrl)
//                         : const AssetImage('assets/images/account.png');
//
//                     final time =
//                     msg.createdAt != null
//                         ? TimeOfDay.fromDateTime(
//                       DateTime.fromMillisecondsSinceEpoch(
//                         msg.createdAt!,
//                       ),
//                     ).format(context)
//                         : '';
//
//                     if (msg is types.TextMessage) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         child: _buildMessageBubble(
//                           isSender: isSender,
//                           name: name,
//                           message: msg.text,
//                           time: time,
//                           imageUrl: displayImage,
//                         ),
//                       );
//                     } else if (msg is types.ImageMessage) {
//                       return msg.uri.isNotEmpty
//                           ? Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         child: _buildImageMessageBubble(
//                           isSender: isSender,
//                           name: name,
//                           imageFile: File(msg.uri),
//                           time: time,
//                           imageUrl: displayImage,
//                         ),
//                       )
//                           : const SizedBox.shrink();
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 );
//               }),
//             ),
//
//             /// Message Input
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               color: Colors.grey[100],
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.photo),
//                     onPressed: controller.handleImagePick,
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: messageController,
//                       decoration: const InputDecoration(
//                         hintText: 'Type a message...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send),
//                     onPressed: () {
//                       final text = messageController.text.trim();
//                       if (text.isNotEmpty) {
//                         controller.handleSendPressed(
//                           types.PartialText(text: text),
//                         );
//                         messageController.clear();
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//             /// Book Now Section
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 8,
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFDCE6FF),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         'Are you satisfied with this conversation?',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         // Book Now logic here
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.blue,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         'Book Now',
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Bubble for text messages
//   Widget _buildMessageBubble({
//     required bool isSender,
//     required String name,
//     required String message,
//     required String time,
//     required ImageProvider imageUrl,
//   }) {
//     final alignment =
//     isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
//     final bubbleColor = isSender ? Color(0xFF114BCA) : Colors.white;
//     final textColor = isSender ? Colors.white : Colors.black87;
//     final radius =
//     isSender
//         ? BorderRadius.only(
//       topLeft: Radius.circular(16),
//       topRight: Radius.circular(0),
//       bottomLeft: Radius.circular(16),
//       bottomRight: Radius.circular(16),
//     )
//         : BorderRadius.only(
//       topLeft: Radius.circular(0),
//       topRight: Radius.circular(16),
//       bottomLeft: Radius.circular(16),
//       bottomRight: Radius.circular(16),
//     );
//
//     return Row(
//       mainAxisAlignment: alignment,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (!isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
//         if (!isSender) const SizedBox(width: 8),
//         Flexible(
//           child: Column(
//             crossAxisAlignment:
//             isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: bubbleColor,
//                   borderRadius: radius,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(message, style: TextStyle(color: textColor)),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const SizedBox(width: 4),
//                   Text(
//                     time,
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   const SizedBox(width: 4),
//                   Icon(
//                     Icons.done_all,
//                     size: 16,
//                     color: isSender ? Colors.white : Colors.green,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         if (isSender) const SizedBox(width: 8),
//         if (isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
//       ],
//     );
//   }
//
//   /// Bubble for image messages
//   Widget _buildImageMessageBubble({
//     required bool isSender,
//     required String name,
//     required File imageFile,
//     required String time,
//     required ImageProvider imageUrl,
//   }) {
//     final alignment =
//     isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
//     final radius =
//     isSender
//         ? const BorderRadius.only(
//       topLeft: Radius.circular(16),
//       topRight: Radius.circular(0),
//       bottomLeft: Radius.circular(16),
//       bottomRight: Radius.circular(16),
//     )
//         : const BorderRadius.only(
//       topLeft: Radius.circular(0),
//       topRight: Radius.circular(16),
//       bottomLeft: Radius.circular(16),
//       bottomRight: Radius.circular(16),
//     );
//
//     return Row(
//       mainAxisAlignment: alignment,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (!isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
//         if (!isSender) const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment:
//           isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: isSender ? Colors.blue[200] : Colors.grey[300],
//                 borderRadius: radius,
//               ),
//               child: ClipRRect(
//                 borderRadius: radius,
//                 child: Image.file(
//                   imageFile,
//                   width: 200,
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   time,
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//                 const SizedBox(width: 4),
//                 Icon(
//                   Icons.done_all,
//                   size: 16,
//                   color: isSender ? Colors.blue : Colors.green,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         if (isSender) const SizedBox(width: 8),
//         if (isSender) CircleAvatar(backgroundImage: imageUrl, radius: 20),
//       ],
//     );
//   }
// }
//