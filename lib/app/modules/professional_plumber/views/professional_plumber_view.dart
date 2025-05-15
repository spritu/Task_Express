import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../home/controllers/home_controller.dart';
import '../../professional_profile/views/professional_profile_view.dart';
import '../controllers/professional_plumber_controller.dart';

class ProfessionalPlumberView extends GetView<ProfessionalPlumberController> {


   ProfessionalPlumberView({super.key});
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final List users = arguments['users'];
    final String title = arguments['title'] ?? 'Professionals';
    return Scaffold(
      backgroundColor: const Color(0xFFD9E4FC),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9E4FC),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w400,
            fontFamily: "poppins",
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on, color: Colors.black),
                    SizedBox(width: 5),
                    Text(
                      "Scheme No 54",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Fh-289, Vijay nagar, Indore"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // List of workers
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  final imagePath = user['userImg'] ?? '';
                  final imageUrl = 'https://jdapi.youthadda.co/$imagePath';

                  final charge = user['skills'] != null && user['skills'].isNotEmpty
                      ? user['skills'][0]['charge']
                      : 0;
                  print("Opening bottom sheet for ${user['firstName']}");

                  return InkWell(
                    onTap: () {
                      // Passing only the relevant data to the bottom sheet
                      Get.bottomSheet(
                      showAfterCallSheet(
                      context,
                      name: user['firstName'] ?? 'No Name',
    imageUrl: user['userImg'] ?? '',
    experience: user['experience'] ?? '',
    phone: user['phone'] ?? '',
    userId: user['_id'],
    title: title,
    ),
    isScrollControlled: true,
    );

                    },
                    child: Container(width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    imageUrl,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/account.png',
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${user['experience']} year Experience",
                                    style: const TextStyle(
                                        color: Color(0xff7C7C7C),
                                        fontSize: 10,
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          user['firstName'] ?? 'No Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            fontFamily: "poppins",
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "✅",
                                                  style: TextStyle(fontSize: 6),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Text(
                                              "Available",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        // Passing only relevant data to navigate to the profile view
                                        Get.to(() => ProfessionalProfileView(), arguments: {
                                          'name': user['firstName'],
                                          'image': user['userImg'],
                                          'experience': user['experience'],
                                          'phone': user['phone'],
                                          'id': user['id'],
                                        });
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 54,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Color(0xff114BCA),
                                        ),
                                        child: Center(
                                          child: const Text(
                                            "Details",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 7,
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 3),
                                              child: Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 14,
                                              color: AppColors.grey,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 10.0,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.orange,
                                              fontFamily: 'Poppins',
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Charge: ",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.orage,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "₹ $charge/day",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.orage,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 24,
                                        width: 110,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final phoneNumber = user['phone'] ?? '';
                                            if (phoneNumber.isNotEmpty) {
                                              controller.makePhoneCall(phoneNumber);
                                            } else {
                                              Get.snackbar('Error', 'Phone number not available',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff114BCA),
                                          ),
                                          child: const Text(
                                            "Call",
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.white, fontFamily: "poppins"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: SizedBox(
                                        height: 24,
                                        width: 100,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final receiverId = user['id'].toString();
                                            if (receiverId.isNotEmpty) {
                                              Get.toNamed('/chat', arguments: {
                                                'receiverId': receiverId,
                                                'receiverName': user['firstName'] ?? 'No Name',
                                                'receiverImage': user['userImg'] ?? '',
                                              });
                                            } else {
                                              Get.snackbar('Error', 'Receiver ID not available',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff114BCA),
                                          ),
                                          child: const Text(
                                            "Chat",
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.white, fontFamily: "poppins"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
   Widget showAfterCallSheet(
       BuildContext context, {
         required String name,
         required String imageUrl,
         required String experience,
         required String phone,
         required String userId,
         required String title,
       }) {
     return SingleChildScrollView(
       child: Container(width: MediaQuery.of(context).size.width,
         padding: const EdgeInsets.all(16),
         decoration: const BoxDecoration(
           color: Color(0xffD9E4FC),
           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             const SizedBox(height: 10),
             CircleAvatar(
               radius: 40,
               backgroundImage: imageUrl.isNotEmpty
                   ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
                   : const AssetImage('assets/images/account.png') as ImageProvider,
             ),
             const SizedBox(height: 10),
             Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             const SizedBox(height: 20),

             /// Main Container
             Container(
               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
               ),
               child: Column(
                 children: [
                   const Text(
                     "Are you satisfied with this conversation?",
                     style: TextStyle(
                       fontSize: 12,
                       fontWeight: FontWeight.w500,
                       fontFamily: "poppins",
                       color: Color(0xFF4F4F4F),
                     ),
                   ),
                   const SizedBox(height: 16),
                   /// Book Now Button
                   SizedBox(
                     height: 42,
                     width: 176,
                     child: ElevatedButton(
                       onPressed: () {
                         Navigator.pop(context); // Close current sheet
                         showModalBottomSheet(
                           context: context,
                           isScrollControlled: true,
                           backgroundColor: Colors.transparent,
                           shape: const RoundedRectangleBorder(
                             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                           ),
                           builder: (context) => showAreUSureSheet(
                             context,
                             name: name,
                             imageUrl: imageUrl,
                             experience: experience,
                             phone: phone,
                             userId: userId,
                             title: title,
                           ),
                         );
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: const Color(0xFF114BCA),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                       child: const Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.check, color: Colors.white, size: 18),
                           SizedBox(width: 10),
                           Text(
                             "Book Now",
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.w500,
                               fontFamily: "poppins",
                               color: Colors.white,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   const SizedBox(height: 16),

                   const Text(
                     "Not Satisfied, let’s find another",
                     style: TextStyle(
                       fontFamily: "poppins",
                       fontWeight: FontWeight.w500,
                       fontSize: 12,
                       color: Color(0xFF4F4F4F),
                     ),
                   ),
                   const SizedBox(height: 10),

                   /// Cancel Button
                   SizedBox(
                     height: 42,
                     width: 176,
                     child: ElevatedButton(
                       onPressed: () {
                         Navigator.pop(context);
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                       child: const Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.close, color: Color(0xFF114BCA), size: 18),
                           SizedBox(width: 10),
                           Text(
                             "Cancel",
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.w500,
                               fontFamily: "poppins",
                               color: Color(0xFF114BCA),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
             const SizedBox(height: 16),
           ],
         ),
       ),
     );
   }


   Widget showAreUSureSheet(
       BuildContext context, {
         required String name,
         required String imageUrl,
         required String experience,
         required String phone,
         required String userId,
         required String title,
       }) {
     return SingleChildScrollView(

       child: Container(width: MediaQuery.of(context).size.width,
         padding: const EdgeInsets.all(16),
         decoration: const BoxDecoration(
           color: Color(0xffD9E4FC),
           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             /// Close button
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 GestureDetector(
                   onTap: () => Navigator.pop(context),
                   child: Icon(Icons.close, color: Colors.black),
                 ),
               ],
             ),

             /// Profile Picture
             CircleAvatar(
               radius: 40,
               backgroundImage: imageUrl.isNotEmpty
                   ? NetworkImage('https://jdapi.youthadda.co/$imageUrl')
                   : const AssetImage('assets/images/account.png') as ImageProvider,
             ),
             SizedBox(height: 8),

             /// Name
             Text(
               name,
               style: TextStyle(
                 fontFamily: "poppins",
                 fontWeight: FontWeight.w500,
                 fontSize: 16,
               ),
             ),
             SizedBox(height: 20),

             /// Main content
             Container(
               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
               ),
               child: Column(
                 children: [
                   Text(
                     "Are you sure you want to continue with this booking?",
                     style: TextStyle(
                       fontSize: 12,
                       fontWeight: FontWeight.w500,
                       fontFamily: "poppins",
                       color: Color(0xFF4F4F4F),
                     ),
                   ),
                   SizedBox(height: 16),

                   /// Yes Button
                   SizedBox(
                     height: 42,
                     width: 176,
                     child: ElevatedButton(
                       onPressed: () async {
                         Navigator.pop(context);
                         await controller.bookServiceProvider(userId);
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Color(0xFF114BCA),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.check, color: Colors.white, size: 18),
                           SizedBox(width: 10),
                           Text(
                             "Yes",
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.w500,
                               fontFamily: "poppins",
                               color: Colors.white,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   SizedBox(height: 16),

                   /// No Button
                   SizedBox(
                     height: 42,
                     width: 176,
                     child: ElevatedButton(
                       onPressed: () => Navigator.pop(context),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.close, color: Color(0xFF114BCA), size: 18),
                           SizedBox(width: 10),
                           Text(
                             "No",
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.w500,
                               fontFamily: "poppins",
                               color: Color(0xFF114BCA),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
   }

}
