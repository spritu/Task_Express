import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

    Get.put(ProfessionalPlumberController());
    final arguments = Get.arguments as Map<String, dynamic>;
    final List users = arguments['users'];
    final String title = arguments['title'] ?? 'Professionals';
    final int avail = arguments['avail'] ?? 0;  final String catId = arguments['catId'] ?? ''; // 🟢 Use this for sorting
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
          ),SizedBox(height: 10),Container(
            width: MediaQuery.of(context).size.width,
            height: 52,
            margin: const EdgeInsets.only( left: 16,right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0x0D323232), // #3232320D = black with 5% opacity
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildToggleButton("charge", "Search by Charge",catId),
                buildToggleButton("distance", "Search by Distance",catId),
              ],
            )),
          ),

          const SizedBox(height: 10),
          // List of workers
          Expanded(
            child: Obx(
                  () { if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }


                  return
                    ListView.builder(
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        final user = controller.users[index];


                        final imagePath = user['userImg'] ?? '';
                        final imageUrl = imagePath.isNotEmpty
                            ? 'https://jdapi.youthadda.co/$imagePath'
                            : '';
                        String rawDistance = user['distance'] ?? "0.00 km";
                        String distanceOnly = rawDistance.replaceAll(" km", "");

                        double? distanceDouble = double.tryParse(distanceOnly);
                        String finalDistance = distanceDouble != null
                            ? "${distanceDouble.toStringAsFixed(2)} km"
                            : "N/A";

                        final int avail = user["avail"] ?? 0;
                        final distance = user['distance'] ?? 'N/A';
                        final charge =
                        user['skills'] != null && user['skills'].isNotEmpty
                            ? user['skills'][0]['charge']
                            : 0;
                        print("Opening bottom sheet for ${user['firstName']}");
                        final coords = user['location']?['coordinates'];
                        final matchedCharge = (user['matchedCharge'] != null && user['matchedCharge'] > 0)
                            ? user['matchedCharge']
                            : (user['skills'] != null && user['skills'].isNotEmpty
                            ? user['skills'][0]['charge']
                            : 0);




                        if (coords != null && coords.length >= 2) {
                          try {
                            final double lat = (coords[1] as num).toDouble();
                            final double lng = (coords[0] as num).toDouble();

                            // Replace below with your method to calculate distance from user location
                            //   distance = controller.getAddressFromLatLng(lat, lng) as double;
                          } catch (e) {
                            print("Coordinate parse error: $e");
                          }
                        }
                        return InkWell(
                          onTap: () async {
                            Get.to(
                                  () => ProfessionalProfileView(),
                              arguments: {
                                'name': user['firstName'],
                                'image': user['userImg'],
                                'experience': user['experience'],
                                'phone': user['phone'],
                                'id': user['_id'],
                                'skills': user['skills'] ?? [],
                                'averageRating': user['averageRating'],
                                'reviews': user['reviews'] ?? [],
                                'avail': user['avail'],
                                // 'latitude': user['latitude'],
                                // 'longitude': user['longitude'],
                                //'distance': user['distance'], // ✅ Add this
                              },
                            );
                          },
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
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
                                        SizedBox(height: 80,
                                          width: 80,
                                          child: Image.network(
                                            imageUrl,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                stackTrace) {
                                              return Image.asset(
                                                'assets/images/person.jpeg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 16,
                                            ), Text(
                                              user['averageRating']
                                                  ?.toString() ?? '0',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "poppins",
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${user['experience'] ??
                                              0} year Experience",
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(crossAxisAlignment: CrossAxisAlignment
                                          .start,

                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                "${user['firstName'] ??
                                                    'No'} ${user['lastName'] ??
                                                    'Name'}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  fontFamily: "poppins",
                                                  color: AppColors.textColor,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  avail == 1
                                                      ? Row(
                                                    children: [
                                                      Icon(Icons.check_circle,
                                                          color: Colors.green,
                                                          size: 16),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        "Available",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: "poppins",
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Color(
                                                              0xff11AD0E),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                      : Row(
                                                    children: [
                                                      Icon(Icons.cancel,
                                                          color: Colors.red,
                                                          size: 16),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        "Not Available",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: "poppins",
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],),
                                                ],),
                                            ],),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              // Passing only relevant data to navigate to the profile view
                                              Get.to(
                                                    () =>
                                                    ProfessionalProfileView(),
                                                arguments: {
                                                  'name': user['firstName'],
                                                  'image': user['userImg'],
                                                  'experience': user['experience'],
                                                  'phone': user['phone'],
                                                  'id': user['_id'],
                                                  'skills': user['skills'] ??
                                                      [],
                                                  'averageRating': user['averageRating'],
                                                  'reviews': user['reviews'] ??
                                                      [],
                                                  'avail': user['avail'],
                                                },);
                                            },
                                            child: Container(
                                              height: 24,
                                              width: 54,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(
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
                                                  ),),),),),
                                        ],),
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
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 3,),
                                                    child: Icon(
                                                      Icons.location_on,
                                                      size: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(finalDistance,
                                                    // ✅ Use calculated distance
                                                    // user['distance'] != null && user['distance'] != 'N/A'
                                                    //     ? '${double.tryParse(user['distance'].toString())?.toStringAsFixed(2) ?? 'N/A'} km'
                                                    //     : 'N/A',
                                                    style: TextStyle(
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                            ],
                                          ),
                                          Card(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(40),
                                            ),
                                            elevation: 2,
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                vertical: 4.0,
                                                horizontal: 4.0,
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
                                                        fontWeight: FontWeight
                                                            .w400,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "₹ $matchedCharge/day",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: AppColors.orage,
                                                        fontWeight: FontWeight
                                                            .w700,
                                                      ),),
                                                  ],),),),),
                                        ],),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        Expanded(child: SizedBox(
                                          height: 24, width: 110,
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
                                                controller.selectedTitle =
                                                    title;
                                                controller
                                                    .shouldShowSheetAfterCall =
                                                true; // Trigger sheet on resume
                                                controller.makePhoneCall(
                                                    phoneNumber);
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
                                              backgroundColor: Color(
                                                  0xff114BCA),
                                            ),
                                            child: const Text(
                                              "Call", style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColors.white,
                                              fontFamily: "poppins",
                                            ),),),),),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: SizedBox(
                                            height: 24,
                                            width: 100,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                final receiverId = user['_id']
                                                    .toString();
                                                final receiverName = '${user['firstName'] ??
                                                    ''} ${user['lastName'] ??
                                                    ''}'.trim();
                                                final receiverImage = user['userImg'] ??
                                                    '';
                                                final phoneNumber = user['phone'] ??
                                                    '';

                                                if (receiverId.isNotEmpty) {
                                                  Get.to(
                                                    ChatView(),
                                                    arguments: {
                                                      'receiverId': receiverId,
                                                      'receiverName': receiverName
                                                          .isNotEmpty
                                                          ? receiverName
                                                          : 'No Name',
                                                      'receiverImage': receiverImage,
                                                      'phoneNumber': phoneNumber,
                                                    },);
                                                } else {
                                                  Get.snackbar(
                                                    'Error',
                                                    'Receiver ID not available',
                                                    snackPosition: SnackPosition
                                                        .BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                    0xff114BCA),
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
                                            ),),),
                                      ],
                                      ),
                                      SizedBox(height: 10),
                                    ],),),
                              ],),),);
                      },);

                  } ),
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
                      print("📌 categoryName ${skill['categoryName']}");
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
  }Widget buildToggleButton(String value, String label, String catId) {
    bool isSelected = controller.selected.value == value;

    return GestureDetector(
      onTap: () async {
        controller.selected.value = value;

        if (value == "charge") {
          await controller.fetchUsersSortedByCharge();
        } else if (value == "distance") {
          print("dissssssssssssssssssssssss");
          // ✅ Get current location before API call
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            print('❌ Location services are disabled.');
            return;
          }

          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              print('❌ Location permission denied');
              return;
            }
          }

          if (permission == LocationPermission.deniedForever) {
            print('❌ Location permissions are permanently denied');
            return;
          }

          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          await controller.fetchUsersWithDistance(

          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          height: 31,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Icon(
                  Icons.circle,
                  size: 14,
                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}