import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../controllers/name_detail_controller.dart';

class NameDetailView extends GetView<NameDetailController> {
  const NameDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> worker = Get.arguments;
    final worker = Get.arguments as Map<String, dynamic>;
    final List<Map<String, dynamic>> skills =
        (worker['skills'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    (worker['skills'] as List).forEach((skill) {
      print(
        'Category: ${skill['categoryName']}, Subcategory: ${skill['subcategoryName']}, Charge: ${skill['charge']}',
      );
    });

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
              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 120),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xffA3EABC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/Verify.png", height: 12),
                      const SizedBox(width: 4),
                      const Text(
                        "Verified",
                        style: TextStyle(
                          fontSize: 8,
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: worker['avail'] == 1 ? Colors.green : Colors.red,
                    size: 10,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    worker['avail'] == 1 ? "Available" : "Not Available",
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                      color: worker['avail'] == 1 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Experience
          Text("${worker['expiresAt'] ?? 'N/A'} year Experience"),

          const SizedBox(height: 20),

          // Professions + Charges
          const Text(
            "Profession:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < skills.length; i++) ...[
                        serviceRow(
                          getDisplayName(skills[i]), // 👈 name to show
                          int.tryParse(skills[i]['charge'].toString()) ??
                              0, // ✅ FIXED
                        ),
                        if (i < skills.length - 1) const Divider(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff114BCA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Call action
                  },
                  child: const Text("Call"),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff114BCA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Chat action
                  },
                  child: const Text("Chat"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Ratings & Reviews
          const Text(
            "Ratings & Reviews",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text("4.7 ⭐", style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text("69 Ratings"),
              SizedBox(width: 8),
              Text("4 Reviews"),
            ],
          ),
          const SizedBox(height: 16),
          reviewCard(
            "Sravan T.",
            "09/04/2025",
            "Amit was super professional and arrived right on time...",
          ),
          reviewCard(
            "Shivani Singh",
            "01/04/2025",
            "Fast, reliable, and affordable—highly recommended!",
          ),
          reviewCard(
            "Ruchi Trivedi",
            "26/03/2025",
            "I booked Amit for a full bathroom fixture installation...",
          ),
        ],
      ),
    );
  }

  Widget professionTile(String title, dynamic charge) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            "Charge ₹ $charge",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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

  Widget serviceRow(String name, int charge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Text(
              'Charge:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Text(
              '₹$charge',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  String getDisplayName(Map<String, dynamic> skill) {
    final subcategoryName = skill['subcategoryName']?.toString().trim();
    final categoryName = skill['categoryName']?.toString().trim();

    if (subcategoryName != null &&
        subcategoryName.isNotEmpty &&
        subcategoryName != 'null') {
      return subcategoryName;
    } else if (categoryName != null &&
        categoryName.isNotEmpty &&
        categoryName != 'null') {
      return categoryName;
    } else {
      return 'Unknown';
    }
  }
}
