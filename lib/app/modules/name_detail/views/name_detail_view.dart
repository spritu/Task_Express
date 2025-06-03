import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../colors.dart';
import '../controllers/name_detail_controller.dart';

class NameDetailView extends GetView<NameDetailController> {
  const NameDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> worker = Get.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://jdapi.youthadda.co/${worker['userImg'] ?? ''}",
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 120),
            ),
          ),
          const SizedBox(height: 16),

          // Name + Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${worker['firstName']} ${worker['lastName']}",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18),
                  Text(
                    "${worker['distance'] ?? 'N/A'} km ",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Status
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.check_circle,
                      color: worker['avail'] == 1 ? Colors.green : Colors.red,
                      size: 10),
                  const SizedBox(width: 4),
                  Text(
                    worker['avail'] == 1 ? "Available" : "Not Available",
                    style: TextStyle(
                        fontSize: 8,fontFamily: "poppins",fontWeight: FontWeight.w500,
                        color: worker['avail'] == 1 ? Colors.green : Colors.red),
                  ),
                ],
              ),

            ],
          ),

          const SizedBox(height: 10),

          // Experience and Jobs
          Text("${worker['expiresAt']} year Experience"),

          const SizedBox(height: 20),

          // Visiting charge note

          // Professions + Charges
          const Text("Profession:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),

          Card(color: AppColors.white,
              child: Column(
            children: [
              professionTile("Plumber", worker['charge']),
              professionTile("Electrician", worker['charge']),
              professionTile("Carpenter", worker['charge']),

            ],
          )),


          const SizedBox(height: 20),

          // Buttons
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

                    // final phoneNumber = phone ?? '';
                    // if (phoneNumber.isNotEmpty) {
                    //   controller.makePhoneCall(phoneNumber);
                    // } else {
                    //   Get.snackbar('Error', 'Phone number not available',
                    //     snackPosition: SnackPosition.BOTTOM,
                    //     backgroundColor: Colors.red,
                    //     colorText: Colors.white,
                    //   );
                    // }

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
                 //   Get.to(ChatView());
                  },
                  child: const Text("Chat"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Ratings & Reviews
          const Text("Ratings & Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("4.7 ⭐", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text("69 Ratings"),
              const SizedBox(width: 8),
              const Text("4 Reviews"),
            ],
          ),
          const SizedBox(height: 16),

          reviewCard("Sravan T.", "09/04/2025",
              "Amit was super professional and arrived right on time..."),
          reviewCard("Shivani Singh", "01/04/2025",
              "Fast, reliable, and affordable—highly recommended!"),
          reviewCard("Ruchi Trivedi", "26/03/2025",
              "I booked Amit for a full bathroom fixture installation..."),
        ],
      ),
    );
  }

  Widget professionTile(String title, dynamic charge) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: const [
      //     BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
      //   ],
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text("Charge ₹ ${charge ?? '300'}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget reviewCard(String name, String date, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, size: 14, color: Colors.blue),
              const SizedBox(width: 6),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text("5 ⭐"),
            ],
          ),
          const SizedBox(height: 4),
          Text("Reviewed on: $date", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
