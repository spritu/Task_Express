import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../colors.dart';
import '../../ServiceCompletedSuccessfully/views/service_completed_successfully_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../controllers/service_completed_controller.dart';

class ServiceCompletedView extends GetView<ServiceCompletedController> {
  const ServiceCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> booking = Get.arguments;

    DateTime createdAt =
        DateTime.tryParse(booking['createdAt'] ?? '') ?? DateTime.now();
    DateTime updatedAt =
        DateTime.tryParse(booking['updatedAt'] ?? '') ?? DateTime.now();

    final formattedDate = DateFormat('d MMM, yyyy').format(createdAt);
    final startTime = DateFormat('hh:mm a').format(createdAt);
    final endTime = DateFormat('hh:mm a').format(updatedAt);
    final duration = updatedAt.difference(createdAt);
    final durationHours = duration.inHours;
    final durationMinutes = duration.inMinutes % 60;
    final String durationString =
        durationHours > 0
            ? '$durationHours Hours${durationMinutes > 0 ? " $durationMinutes Minutes" : ""}'
            : '$durationMinutes Minutes';

    Get.put(ServiceCompletedController());

    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: AppColors.appGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),

                      const Text(
                        "Service Completed",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: "poppins",
                        ),
                      ),
                      Text(""),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.asset("assets/images/service.png"),
                  const SizedBox(height: 5),

                  // Top Info
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFD9E4FC),
                        ),
                        color: Colors.white,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${booking['data']['bookedFor']['firstName']} ${booking['data']['bookedFor']['lastName']}",

                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                fontFamily: "poppins",
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " has completed the work at your location. Please review the details below and proceed to payment.",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: "poppins",
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Work Summary
                  Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFD9E4FC),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Work Summary",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          summaryRow(
                            "Worker",
                            "${booking['data']['bookedFor']['firstName']} ${booking['data']['bookedFor']['lastName']}",
                            valueColor: const Color(0xFF114BCA),
                          ),
                          summaryRow("Duration", durationString),
                          summaryRow(
                            "Charge",
                            "${booking['data']['bookedFor']['skills'].isNotEmpty ? booking['data']['bookedFor']['skills'][0]['charge'] : 'N/A'}",
                          ),
                          summaryRow("Date", formattedDate),
                          summaryRow("Time", '$startTime - $endTime'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Rate & Review
                  Container(
                    height: 242,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFFD9E4FC),
                      border: Border.all(color: const Color(0xFFD9E4FC)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rate & Review",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 53,
                          width: 273,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFD9E4FC)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "How was your experience with Suraj Sen?",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(
                                () => RatingBar.builder(
                                  initialRating: controller.rating.value,
                                  minRating: 1,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 18,
                                  direction: Axis.horizontal,
                                  itemBuilder:
                                      (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                  unratedColor: Colors.grey.shade400,
                                  onRatingUpdate: controller.setRating,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // TextField
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          height: 79,
                          width: 341,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFD9E4FC)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged:
                                (value) => controller.review.value = value,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "Write a short review here…",
                              hintStyle: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF9E9E9E),
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontFamily: "poppins",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Submit Button
                        Center(
                          child: SizedBox(
                            height: 37,
                            width: 105,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.submitReview(controller.bookingId.value);
                                Get.to(ServiceCompletedSuccessfullyView());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF114BCA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 14,
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
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget summaryRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "poppins",
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontFamily: "poppins",
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
