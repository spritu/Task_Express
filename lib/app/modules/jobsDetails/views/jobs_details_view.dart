import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../controllers/jobs_details_controller.dart';

class JobsDetailsView extends GetView<JobsDetailsController> {
  const JobsDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(JobsDetailsController());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(onTap: (){
                      Get.back();
                    },
                        child: Icon(Icons.arrow_back)),
                    Text(
                      "Jobs Detail",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(""),
                  ],
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Job Id #3421456778865",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: "poppins",
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Help",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: "poppins",
                                color: Color(0xFFF67C0A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                               // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Name - takes remaining space
                                  Text(
                                    "Sourabh Mittal",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),

                                  SizedBox(
                                    width:
                                    MediaQuery.of(context).size.width*0.4,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(
                                        Icons
                                            .fiber_manual_record, // this gives you a dot look
                                        size: 12,
                                        color: Color(0xFF0BB034), // Green
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Job Done",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF595959),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "E7, 775,",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF595959),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Saket Nagar, Indore, 452020",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF595959),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              buildListTile(
                                "assets/images/jobasing.png",
                                "Job assigned on",
                                "12 Dec 2024, 10:30 PM",
                              ),
                              const SizedBox(height: 10),
                              buildListTile(
                                "assets/images/jobcomp.png",
                                "Job Completed on",
                                "12 Dec 2024, 05:50 PM",
                              ),
                              const SizedBox(height: 10),
                              buildListTile(
                                "assets/images/userline.png",
                                "Booked for",
                                "Basic Plumbing work",
                                highlightRightText: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          height: 37,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: "Work Duration: ",
                                          style: TextStyle(
                                            color: Color(0xFF595959),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "7 hrs, 20 mins",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Earn: ",
                                        style: TextStyle(
                                          color: Color(0xFFF67C0A),
                                        ),
                                      ),
                                      TextSpan(
                                        text: "₹ 450",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFF67C0A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Card(
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFFFFCC9E),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 5,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Job note",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                    Image.asset("assets/images/edit.png"),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    height: 52,
                                    width: 352,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Kitchen sink tap leakage fix , might need pipe\nreplacement in future.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "poppins",
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Rating & Review",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Color(0xFFF67C0A)), // orange border
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: controller.rating.value,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 16,
                                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Color(0xFFFFC107),
                                        ),
                                        onRatingUpdate: (rating) {
                                          controller.rating.value = rating; // ✅ Update value
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Obx(() => Text(
                                        "${controller.rating.value.toStringAsFixed(1)}/5", // ✅ Reactive value
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "“Suraj was extremely professional and punctual. He fixed the plumbing issue quickly and explained everything clearly. Very satisfied with the service. Highly recommended!”",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(
      String iconPath,
      String leftText,
      String rightText, {
        bool highlightRightText = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 18,
              height: 18,
              color: Color(0xFF595959),
            ),
            const SizedBox(width: 8),
            Text(
              leftText,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF595959),
              ),
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              rightText,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight:
                highlightRightText ? FontWeight.w500 : FontWeight.w400,
                color:
                highlightRightText ? Color(0xFFF67C0A) : Color(0xFF1A1A1A),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }
}