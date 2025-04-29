import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../professional_profile/views/professional_profile_view.dart';
import '../controllers/professional_plumber_controller.dart';

class ProfessionalPlumberView extends GetView<ProfessionalPlumberController> {
  const ProfessionalPlumberView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E4FC),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9E4FC),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Professional Plumber",
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
                itemCount: controller.workers.length,
                itemBuilder: (context, index) {
                  final worker = controller.workers[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    //  padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Card(color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    worker['image'],
                                    height: 80,
                                    width: 94,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      "${worker['rating']} (${worker['reviews']} reviews)",
                                      style: const TextStyle(color: Colors.grey,fontSize: 11,fontFamily: "poppins",fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${worker['experience']} year Experience",
                                  style: const TextStyle(color: Color(0xff7C7C7C),fontSize: 10,fontFamily: "poppins",fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    worker['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontFamily: "poppins",
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(ProfessionalProfileView());
                                    },
                                    child: Container(
                                      height: 19,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
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
                              if (worker['available'])
                                Row(
                                  children: [
                                    Container(
                                      width:10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text("✅", style: TextStyle(fontSize: 6)),
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
                                ),SizedBox(height: 5),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // const Icon(
                                  //   Icons.location_on,
                                  //   size: 12,
                                  //   color: Colors.grey,
                                  // ),
                                  Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [Padding(
                                          padding: const EdgeInsets.only(top: 3),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                          Text(
                                            "${worker['distance']} "
                                            ,
                                            style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w500,fontFamily: "poppins"),
                                          ),
                                        ],
                                      ), Row(
                                        children: [Icon(Icons.access_time,size: 10,color: AppColors.grey,),
                                          Text(
                                            "${worker['time']} away",
                                            style: const TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w500,fontFamily: "poppins"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),Card(color:AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(color: Colors.black12), // optional border
                                    ),
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                                          children: [
                                            const TextSpan(
                                              text: "Charge:\n",
                                              style: TextStyle(fontSize: 10,color: AppColors.blue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "₹ 250/day",
                                              style: TextStyle(
                                                fontSize: 10,color: AppColors.blue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              ),


                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(height:24,width:110,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //controller.showAfterCallSheet(context);
                                          },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff114BCA),
                                        ),
                                        child: const Text("Call",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: AppColors.white,fontFamily: "poppins"),),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(height:24,width:100,

                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:Color(0xff114BCA),
                                        ),
                                        child: const Text("Chat",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: AppColors.white,fontFamily: "poppins")),
                                      ),
                                    ),
                                  ),
                                ],
                              ),SizedBox(height: 10,)
                            ],
                          ),
                        ),
                      ],
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
}
