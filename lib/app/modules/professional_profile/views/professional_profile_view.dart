import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../chat/views/chat_view.dart';
import '../controllers/professional_profile_controller.dart';

class ProfessionalProfileView extends GetView<ProfessionalProfileController> {

  const ProfessionalProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfessionalProfileController());
    final args = Get.arguments as Map<String, dynamic>;

    final arguments = Get.arguments as Map<String, dynamic>;
    final String appBarTitle = arguments['title'] ?? 'Professional Profile';
    final String name = arguments['name'] ?? '';
    final String avgRating = arguments['averageRating']?.toString() ?? 'No rating';
    final String imagePath = arguments['image'] ?? '';
    final String imageUrl = 'https://jdapi.youthadda.co/$imagePath';
    final String experience = arguments['experience']?.toString() ?? '';
    final String phone = arguments['phone'] ?? '';
    final List<Map<String, dynamic>> skills = (arguments['skills'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
    final List<Map<String, dynamic>> reviews = (arguments['reviews'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
    final int avail = arguments['avail'] ?? 0;
    final int totalRatings = reviews.length;
    final int totalReviews = reviews.where((review) => review['review'] != null && review['review'].toString().trim().isNotEmpty).length;
final String? distance = arguments['distance']?.toString();
final String distanceText = distance != null ? '$distance km away' : 'Distance not available';
// Example log
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(backgroundColor: AppColors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [Color(0xFF87AAF6), Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            padding:  EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:  Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      appBarTitle,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(""),
                  ],
                ),
                SizedBox(
                  height: 234,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/person.jpeg',
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Name, Distance, Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: "poppins",
                      ),
                    ),
                    Row(
                      children:  [
                        Icon(Icons.location_on, size: 17, color: Colors.grey),
                        Text(
                          distanceText,
                          style: TextStyle(fontSize: 12),
                        )
                        // Text(
                        //   "2 km ",
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //     fontWeight: FontWeight.w400,
                        //     fontSize: 12,
                        //     fontFamily: "poppins",
                        //   ),
                        // ),
                        // Text(
                        //   "(20 mins away)",
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //     fontWeight: FontWeight.w500,
                        //     fontSize: 12,
                        //     fontFamily: "poppins",
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 41,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Color(0xffA3EABC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset("assets/images/Verify.png"),
                            Text(
                              "Verified",
                              style: TextStyle(
                                fontSize: 6,
                                fontFamily: "poppins",
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    avail == 1
                        ? Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Available",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            color: Color(0xff11AD0E),
                          ),
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Not Available",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${experience.isNotEmpty ? experience : "0"} year Experience",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Text(
                      "120+ Jobs completed",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children:  [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      avgRating,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        fontFamily: "poppins",
                        color: Color(0xff1B1B1B),
                      ),
                    ),
                    Text(
                      "($totalReviews Reviews)",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                        fontFamily: "poppins",
                        color: Color(0xff235CD7),
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 10),
                // Container(width: MediaQuery.of(context).size.width,
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFD9E4FC),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: const Text.rich(
                //     TextSpan(
                //       children: [
                //         TextSpan(
                //           text: "Visiting Charge: ",
                //           style: TextStyle(
                //             fontWeight: FontWeight.w500,
                //             fontSize: 13,
                //             color: Colors.grey,
                //           ),
                //         ),
                //         TextSpan(
                //           text: "₹ 50+ Extra charge ",
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontWeight: FontWeight.w500,
                //             fontSize: 13,
                //           ),
                //         ),
                //         TextSpan(
                //           text: "as per work",
                //           style: TextStyle(
                //             color: Colors.grey,
                //             fontWeight: FontWeight.w500,
                //             fontSize: 13,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                const SizedBox(height: 16),
                const Text(
                  "Profession:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "poppins",
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 287,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Column(
                          children: [
                            for (int i = 0; i < skills.length; i++) ...[
                              serviceRow(
                                getDisplayName(skills[i]), // 👈 name to show
                                skills[i]['charge'] ?? 0,
                              ),
                              if (i < skills.length - 1) const Divider(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),



                // const SizedBox(height: 16),
                // const Text(
                //   "Work Expertise:",
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     fontSize: 14,
                //     fontFamily: "poppins",
                //     color: AppColors.textColor,
                //   ),
                // ),
                //
                // const SizedBox(height: 8),
                // Text.rich(
                //   TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "• Plumbing Installations & Repairs – ",
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black,
                //           fontSize: 11,
                //         ),
                //       ),
                //       TextSpan(
                //         text:
                //             "Install and fix pipes, faucets, sinks, toilets, water heaters, and other plumbing systems.",
                //         style: TextStyle(
                //           color: Colors.grey[700],
                //           fontWeight: FontWeight.w500,
                //           fontSize: 11,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 6),
                // Text.rich(
                //   TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "• Leak Detection & Drain Cleaning – ",
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black,
                //           fontSize: 11,
                //         ),
                //       ),
                //       TextSpan(
                //         text:
                //             "Identify and repair leaks, unclog drains, and ensure smooth water flow.",
                //         style: TextStyle(
                //           color: Colors.grey[700],
                //           fontWeight: FontWeight.w500,
                //           fontSize: 11,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 6),
                // Text.rich(
                //   TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "• Emergency & Routine Maintenance – ",
                //         style: TextStyle(
                //           fontWeight: FontWeight.w500,
                //           color: Colors.black,
                //           fontSize: 11,
                //         ),
                //       ),
                //       TextSpan(
                //         text:
                //             "Provide scheduled maintenance and handle urgent plumbing issues efficiently.",
                //         style: TextStyle(
                //           color: Colors.grey[700],
                //           fontWeight: FontWeight.w500,
                //           fontSize: 11,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff114BCA),
                          // 🔵 change this to your desired color
                          foregroundColor: Colors.white,
                          // optional: text/icon color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {

                            final phoneNumber = phone ?? '';
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
                        child: const Text("Call"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff114BCA),
                          // 🔵 change this to your desired color
                          foregroundColor: Colors.white,
                          // optional: text/icon color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
              onPressed: () {
                Get.to(ChatView());
                       },
                        child: const Text("Chat"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Text(
                  "Ratings & Reviews",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "poppins",
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5),
                    // borderRadius: BorderRadius.circular(12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.3), // Shadow color
                    //     spreadRadius: 2, // How wide the shadow spreads
                    //     blurRadius: 8, // How soft the shadow looks
                    //     offset: const Offset(0, 4), // Move right (x), down (y)
                    //   ),
                    // ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text(
                            avgRating,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                        ],
                      ),

                      //
                      Container(height: 20, width: 1, color: Colors.black26),

                      // Ratings Count
                       Text(
                        '$totalRatings ' +'Ratings',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff114BCA),
                        ),
                      ),

                      // Vertical Divider
                      Container(height: 20, width: 1, color: Colors.black26),

                      // Reviews Count
                       Text(
                        '$totalReviews '+' Reviews',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff114BCA),
                        ),
                      ),
                    ],
                  ),
                ),
                // Vertical Divider
                const SizedBox(height: 10),
                // Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Reviews",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(Icons.tune),
                  ],
                ),
              ..._buildReviews(reviews),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customCheckbox(String title, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // Reduces height
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrinks width to content
        children: [
          Checkbox(
            value: false,
            onChanged: (_) {},
            visualDensity: const VisualDensity(horizontal: -3, vertical: -3), // Makes checkbox smaller
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap area
          ),SizedBox(width: 10,),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: "poppins",
                fontWeight: FontWeight.w500,color: AppColors.textColor
              ),
              overflow: TextOverflow.ellipsis, // Optional: prevent overflow
            ),
          ),
          Text(
            "Charge ₹ $price",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "poppins",
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceRow(String name, int charge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(fontSize: 16)),
        Text('₹$charge', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }



  List<Widget> _buildReviews(List reviews) {
    if (reviews.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "No reviews yet.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: "poppins",
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ];
    }

    return reviews.map((review) {
      final reviewer = review['reviewer'];
      final name = "${reviewer['firstName'] ?? ''} ${reviewer['lastName'] ?? ''}";
      final rating = review['rating'] ?? 0;
      final reviewText = review['review'] ?? '';
      final createdAt = review['createdAt'] ?? '';
      final date = DateTime.tryParse(createdAt);
      final formattedDate = date != null
          ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
          : '';

      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                  fontFamily: "poppins",
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/Verify.png",
                      color: Color(0xff114BCA),
                      height: 12,
                      width: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Verified user",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 8,
                        color: Color(0xff114BCA),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.circle, size: 3, color: Colors.grey),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "Reviewed on $formattedDate",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff858585),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  height: 19,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
                    border: Border.all(width: 0.5, color: AppColors.grey),
                  ),
                  child: Row(
                    children: [
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(Icons.star, color: Color(0xffF5E029), size: 14),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: Text(
                reviewText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  fontFamily: "poppins",
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }



  String getDisplayName(Map<String, dynamic> skill) {
    final subcategoryName = skill['subcategoryName']?.toString().trim();
    final categoryName = skill['categoryName']?.toString().trim();

    if (subcategoryName != null && subcategoryName.isNotEmpty && subcategoryName != 'null') {
      return subcategoryName;
    } else if (categoryName != null && categoryName.isNotEmpty && categoryName != 'null') {
      return categoryName;
    } else {
      return 'Unknown';
    }
  }



}
