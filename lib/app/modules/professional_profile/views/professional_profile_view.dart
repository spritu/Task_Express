import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
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
    final String name = args['name'] ?? '';
    final imagePath = arguments['image'] ?? '';
    final imageUrl = 'https://jdapi.youthadda.co/$imagePath';
    final String experience = args['experience']?.toString() ?? '';
    final String phone = args['phone'] ?? '';
    return Scaffold(backgroundColor: AppColors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFF87AAF6), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                    children: const [
                      Icon(Icons.location_on, size: 17, color: Colors.grey),
                      Text(
                        "3.5 km ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(
                        "(20 mins away)",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          fontFamily: "poppins",
                        ),
                      ),
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
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "Available",
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                      color: Color(0xff11AD0E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    experience+" year Experience",
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
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "4.7",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      fontFamily: "poppins",
                      color: Color(0xff1B1B1B),
                    ),
                  ),
                  Text(
                    "(69 reviews)",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 8,
                      fontFamily: "poppins",
                      color: Color(0xff235CD7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Container(width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E4FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Visiting Charge: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: "₹ 50+ Extra charge ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: "as per work",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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
                child: SizedBox(width: 287,height: 152,
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
                          serviceRow("Plumber", 300),
                          const Divider(),
                          serviceRow("Electrician", 300),
                          const Divider(),
                          serviceRow("Carpenter", 300),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Work Expertise:",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "poppins",
                  color: AppColors.textColor,
                ),
              ),

              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "• Plumbing Installations & Repairs – ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Install and fix pipes, faucets, sinks, toilets, water heaters, and other plumbing systems.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "• Leak Detection & Drain Cleaning – ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Identify and repair leaks, unclog drains, and ensure smooth water flow.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "• Emergency & Routine Maintenance – ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 11,
                      ),
                    ),
                    TextSpan(
                      text:
                          "Provide scheduled maintenance and handle urgent plumbing issues efficiently.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

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
                          '4.7',
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
                    const Text(
                      '69 Ratings',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff114BCA),
                      ),
                    ),

                    // Vertical Divider
                    Container(height: 20, width: 1, color: Colors.black26),

                    // Reviews Count
                    const Text(
                      '4 Reviews',
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
              ..._buildReviews(),SizedBox(height: 20,)
            ],
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

  Widget serviceRow(String title, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: "poppins",
              color: Colors.black,
            ),
          ),Spacer(),
          Text(
            "Charge ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "poppins",
              color: Colors.black54,
            ),
          ),  Text(
            "₹ $price",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: "poppins",
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReviews() {
    List<Map<String, dynamic>> reviews = [
      {
        'name': 'Sravan',
        'date': '09/04/2025',
        'review':
            'Amit was super professional and arrived right on time. He quickly fixed a leaking pipe under the kitchen sink and gave me tips to avoid future issues.',
      },
      {
        'name': 'Shivani Singh',
        'date': '01/04/2025',
        'review': 'Fast, reliable, and affordable—highly recommended!',
      },
      {
        'name': 'Priya Thakur',
        'date': '26/03/2025',
        'review':
            'What I appreciated most was his honesty—he didn’t try to upsell anything and quoted fair prices. Also cleaned up after the work.',
      },
      {
        'name': 'Ruchi Trivedi',
        'date': '26/03/2025',
        'review':
            'Truly professional! Explained everything and was very patient.',
      },
    ];

    return reviews
        .map(
          (r) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 20,),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  r['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                    fontFamily: "poppins",
                  ),
                ),
                subtitle: Row(
                  children: [
                    Image.asset(
                      "assets/images/Verify.png",
                      color: Color(0xff114BCA),
                    ),
                    Text(
                      "Verified user",
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 8, color: Color(0xff114BCA),),
                    ),SizedBox(width: 3),Icon(Icons.circle,size: 3,),SizedBox(width: 3),
                    Text(
                      "Reviewed on: ${r['date']}",
                      style: TextStyle(
                        fontFamily: "poppins",
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff858585),
                      ),
                    ),
                  ],
                ),
                trailing: Container(height: 19,width: 33,
                  decoration: BoxDecoration(border: Border.all(width: 0.5,color: AppColors.grey),
                borderRadius: BorderRadius.circular(3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("5", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12)),SizedBox(width: 3),
                      Icon(Icons.star, color: Colors.amber,size: 12,),
                    ],
                  ),
                ),
              ),
              Text(r['review'],style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,fontFamily: "poppins"),),

            ],
          ),
        )
        .toList();
  }
}
