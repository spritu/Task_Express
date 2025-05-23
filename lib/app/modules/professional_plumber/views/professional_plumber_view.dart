import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../chat/views/chat_view.dart';
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
    print('12345:${users}');

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
                  final lat = double.tryParse(user['lat'] ?? '0') ?? 0.0;
                  final lng = double.tryParse(user['lng'] ?? '0') ?? 0.0;

                  // Trigger distance fetch for each user if not already fetched
                  if (!controller.distances.containsKey(index)) {
                    controller.fetchDistanceForUser(index, lat, lng);
                  }

                  final distance = controller.distances[index] ?? 'Calculating...';
                  final imagePath = user['userImg'] ?? '';
                  final imageUrl = 'https://jdapi.youthadda.co/$imagePath';
                  final charge = user['skills'] != null && user['skills'].isNotEmpty
                      ? user['skills'][0]['charge']
                      : 0;
                  print("Opening bottom sheet for ${user['firstName']}");

                  return InkWell(
                    onTap: () async {
                      // Passing only the relevant data to the bottom sheet
                      Get.bottomSheet(
                        showAfterCallSheet(
                          context,
                          name: user['firstName']?.toString() ?? 'No Name',
                          imageUrl: user['userImg']?.toString() ?? '',
                          experience: user['experience']?.toString() ?? '',
                          phone: user['phone']?.toString() ?? '',
                          userId: user['_id'],
                          title: title,
                          skills: List<Map<String, dynamic>>.from(
                            user['skills'] ?? [],
                          ),
                        ),
                        isScrollControlled: true,
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${user['firstName'] ?? 'No'} ${user['lastName'] ?? 'Name'}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            fontFamily: "poppins",
                                            color: AppColors.textColor,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Row(mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                        Get.to(
                                          () => ProfessionalProfileView(),
                                          arguments: {
                                            'name': user['firstName'],
                                            'image': user['userImg'],
                                            'experience': user['experience'],
                                            'phone': user['phone'],
                                            'id': user['_id'],
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 54,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 14, color: Colors.grey),
                                            SizedBox(width: 4),
                                            Text(
                                              controller.distances[index] ?? 'N/A',style: TextStyle(fontSize: 12),
                                            ),

                                          ],
                                        ),

                                        SizedBox(height: 3),

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
                                          onPressed: () async {
                                            final phoneNumber =
                                                user['phone'] ?? '';
                                            if (phoneNumber.isNotEmpty) {
                                              controller.selectedUsers =
                                                  users; // Store full list
                                              controller
                                                      .selectedIndexAfterCall =
                                                  index; // Store selected index
                                              controller.selectedTitle = title;
                                              controller
                                                      .shouldShowSheetAfterCall =
                                                  true; // Trigger sheet on resume

                                              controller.makePhoneCall(
                                                phoneNumber,
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Error',
                                                'Phone number not available',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColors.white,
                                              fontFamily: "poppins",
                                            ),
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
                                            final receiverId =
                                                user['_id'].toString();
                                            if (receiverId.isNotEmpty) {
                                              Get.to(
                                                ChatView(),
                                                arguments: {
                                                  'receiverId': receiverId,
                                                  'receiverName': '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim().isNotEmpty
                                                      ? '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim()
                                                      : 'No Name',
                                                  'receiverImage':
                                                  user['userImg'] ?? '',
                                                },
                                              );
                                            } else {
                                              Get.snackbar(
                                                'Error',
                                                'Receiver ID not available',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColors.white,
                                              fontFamily: "poppins",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
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
          ),
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
    required List<Map<String, dynamic>> skills, // Pass dynamic skills
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        imageUrl.isNotEmpty
                            ? NetworkImage(
                              'https://jdapi.youthadda.co/$imageUrl',
                            )
                            : const AssetImage('assets/images/account.png')
                                as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "poppins",
                      color: Color(0xFF114BCA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "If this conversation with $name meets your expectations, book now:",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4F4F4F),
                  fontFamily: "poppins",
                ),
              ),
              const SizedBox(height: 20),

              /// 🔁 Generate dynamic profession rows from skills
              for (var skill in skills)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: professionRow(
                    title:
                        (skill['subcategoryName'] != null &&
                                skill['subcategoryName'].toString().isNotEmpty)
                            ? skill['subcategoryName']
                            : (skill['categoryName'] != null &&
                                skill['categoryName'].toString().isNotEmpty)
                            ? skill['categoryName']
                            : 'Service',

                    price: "₹ ${skill['charge'].toString()}",
                    onBookNow: () {
                      print("📌 Book Now tapped for: ${skill['categoryName']}");
                      showAreUSureSheet(
                        context,
                        name: name,
                        imageUrl: imageUrl,
                        experience: experience,
                        phone: phone,
                        userId: userId,
                        title: skill['categoryId'].toString(),
                        skill: skill,
                        bookServiceProvider: (serviceIds) async {
                          await controller.bookServiceProvider(
                            bookedFor: userId,
                            serviceIds: serviceIds,
                            selectedHelperName: '',
                          );
                        },
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
              const Text(
                "Not Satisfied? Let’s help you find someone else",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4F4F4F),
                  fontFamily: "poppins",
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 34,
                width: 119,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Color(0xFF114BCA)),
                  label: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF114BCA),
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF114BCA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget professionRow({
    required String title,
    required String price,
    required VoidCallback onBookNow,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF6F6F6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: "poppins",
            ),
          ),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF114BCA),
                  fontFamily: "poppins",
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 25,
                width: 79,
                child: ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF114BCA),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: "poppins",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showAreUSureSheet(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required String experience,
    required String phone,
    required String userId,
    required String title,
    required Map<String, dynamic> skill,
    required Future<void> Function(List<String> serviceIds) bookServiceProvider,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xffD9E4FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        imageUrl.isNotEmpty
                            ? NetworkImage(
                              'https://jdapi.youthadda.co/$imageUrl',
                            )
                            : const AssetImage('assets/images/account.png')
                                as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Are you sure you want to continue with this booking?",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                            color: Color(0xFF4F4F4F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          width: 176,
                          child: ElevatedButton(
                            onPressed: () async {
                              String serviceId =
                                  skill['subcategoryId']?.toString() ??
                                  skill['categoryId'].toString();
                              Navigator.pop(context);
                              await bookServiceProvider([serviceId]);
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
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
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
                        const SizedBox(height: 16),
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Color(0xFF114BCA),
                                  size: 18,
                                ),
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
          ),
        );
      },
    );
  }
}
