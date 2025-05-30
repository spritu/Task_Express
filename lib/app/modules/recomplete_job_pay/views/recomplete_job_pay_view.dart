import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../colors.dart';
import '../../completejob/controllers/completejob_controller.dart';
import '../controllers/recomplete_job_pay_controller.dart';

class RecompleteJobPayView extends GetView<RecompleteJobPayController> {
  final Map<String, dynamic> paymentData;
  const RecompleteJobPayView({super.key, required this.paymentData});
  @override
  Widget build(BuildContext context) {
    Get.put(RecompleteJobPayController());
    final id = paymentData['_id']?.toString();
    final firstName = paymentData['bookedFor']['firstName'];
    final lastName = paymentData['bookedFor']['lastName'];
    final fullname = "$firstName $lastName";
    final userImg = paymentData['bookedFor']['userImg'];
    print("suv:${paymentData['jobStartTime']}");

    Future<void> manageapi(String id) async {
      if (id.isEmpty) {
        print("❌ Booking ID is empty in manageapi");
        return;
      }

      print("✅ functioncalled34 with bookingId: $id");
      await controller.closeJob(id); // Pass ID to controller
    }

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          gradient: AppColors.appGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Complete Job & Payment",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                    ),
                    const SizedBox(width: 24), // Placeholder for symmetry
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                /// Main Container
                Card(
                  child: Container(
                    height: 510,
                    width: 368,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Service provider has cancelled last amount request Please confirm the amount you paid to the service provider.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                            color: Color(0xFF474747),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: 47.5,
                          backgroundImage: NetworkImage(
                            'https://jdapi.youthadda.co/$userImg',
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fullname,
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Professional Plumber",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Charge Info
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(text: "Date & Time: "),
                              TextSpan(
                                text: controller.formatJobTime(
                                  paymentData['jobStartTime'],
                                ),

                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        /// Amount Box
                        Container(
                          height: 102,
                          width: 326,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF114BCA)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "How much did you pay the worker?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6D6D6D),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 44,
                                width: 260,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "₹ ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "poppins",
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      height: 24,
                                      width: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: TextFormField(
                                        controller: controller.payController,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF6D6D6D),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "e.g. 250",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "poppins",
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF6D6D6D),
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Confirm Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 42,
                              width: 160,
                              child: ElevatedButton(
                                onPressed: () {
                                  print("🟡 opay $id"); // Debug log
                                  manageapi(id.toString());
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF114BCA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Confirm Payment",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "poppins",
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1, // ⬅️ Ensures only one line
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
