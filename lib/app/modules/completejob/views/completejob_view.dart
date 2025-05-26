import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../ServiceCompleted/views/service_completed_view.dart';
import '../controllers/completejob_controller.dart';

class CompletejobView extends GetView<CompletejobController> {
  const CompletejobView({super.key});



  @override
  Widget build(BuildContext context) {

    Get.put(CompletejobController());

    final Map<String, dynamic> booking = Get.arguments;

    print('new data here2222234: ${booking}');

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient:AppColors.appGradient
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Text(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  const SizedBox(height: 20),

                  /// Main Container
                  Card(
                    child: Container(
                      height: 497,
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
                          const Text(
                            "Please confirm the amount you paid to the service provider.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "poppins",
                              color: Color(0xFF474747),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const CircleAvatar(
                            radius: 47.5,
                            backgroundImage: AssetImage(
                              "assets/images/rajesh.png",
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${booking['data']['bookedFor']['firstName']} ${booking['data']['bookedFor']['lastName']}",
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
                                  text:controller.formatCreatedAt1234(booking['data']['createdAt']),
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
                                const Text(
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
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "poppins",
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF6D6D6D),
                                          ),
                                          decoration: const InputDecoration(
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
                                    controller.closeJob(controller.bookingId.value);


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
      ),
    );
  }
}