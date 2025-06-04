import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../name_detail/views/name_detail_view.dart';
import '../controllers/plastering_helper_controller.dart';

class PlasteringHelperView extends GetView<PlasteringHelperController> {
  final Map<String, dynamic> userList = Get.arguments;

  PlasteringHelperView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PlasteringHelperController());

    // Wrap single worker in a list
    final List<Map<String, dynamic>> dataList = [userList];

    return Scaffold(
      backgroundColor: const Color(0xFFD9E4FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9E4FC),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "${userList['firstName'] ?? ''} ${userList['lastName'] ?? ''}",
          style: const TextStyle(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.black),
                    SizedBox(width: 5),
                    Text(
                      "Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Fh-289, Vijay nagar, Indore"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // List of worker(s)
          Expanded(
            child: ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final worker = dataList[index];
                final charge =
                worker['skills'] != null && worker['skills'].isNotEmpty
                    ? worker['skills'][0]['charge'].toString()
                    : 0;
                return InkWell(onTap: (){
                  Get.to(() => NameDetailView(), arguments: worker);
                },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Left: Image + Rating + Experience
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://jdapi.youthadda.co/${worker['userImg'] ?? ''}",
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Icon(Icons.person, size: 80, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  "${worker['rating'] ?? '4.7'} (${worker['reviewCount'] ?? '89'} reviews)",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontFamily: "poppins",
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${worker['expiresAt'] ?? '0'} year Experience",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontFamily: "poppins",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Right: Info & Buttons
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Name + Details Button
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${worker['firstName'] ?? ''} ${worker['lastName'] ?? ''}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff114BCA),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Availability
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
                                      color: worker['avail'] == 1 ? Colors.green : Colors.red,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),
                              // Distance & Time
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                                      Text(
                                        "${worker['distance'] ?? '3.5'} km", // Make it dynamic if needed
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black87,
                                          fontFamily: "poppins",
                                        ),
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
                                             // text: "₹ ${worker['charge'] ?? '0'}/day",
                                              text:charge.toString(),
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
                             // const SizedBox(height: 6),
                              // Charge Pill


                              const SizedBox(height: 10),
                              // Call & Chat Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xff114BCA),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Call",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "poppins",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xff114BCA),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "Chat",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          ),
        ],
      ),
    );
  }
}
