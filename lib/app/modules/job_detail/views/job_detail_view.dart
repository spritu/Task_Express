import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../controllers/job_detail_controller.dart';

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0E6),

      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(   decoration: BoxDecoration(gradient: AppColors.appGradient2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SizedBox(height: 10),Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(""),
                  const Text(
                    '',
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },child: Icon(Icons.close_rounded))
                ],
              ),SizedBox(height: 20),
                // DONE Image (you can replace this with actual asset)
                Image.asset(
                  'assets/images/job_done.png',
                ),
                const SizedBox(height: 16),
                // Done Text
                Card(
                 color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Suraj Sen, ",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text:
                            "You have successfully completed the job at the client’s location. Please wait while the client reviews and completes the payment.",
                            style: TextStyle(
                              fontFamily: "Poppins", fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Work Summary
                Card(
                 color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Work Summary",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,  color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Job Id #7894732453672",
                          style: TextStyle(
                            fontFamily: "Poppins", fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 12),
                        _SummaryRow(label: "User", value: "Shivani singh"),
                        _SummaryRow(label: "Duration", value: "3 Hours"),
                        _SummaryRow(label: "Charge", value: "₹250"),
                        _SummaryRow(label: "Date", value: "7 April, 2025"),
                        _SummaryRow(label: "Time", value: "10:30 AM - 01:30 PM"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Chat Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Needs to follow up?",
                        style: TextStyle(fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontSize: 14,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Chat with User",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10,fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Bottom info
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "For more details, go to ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "Jobs",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontFamily: "Poppins"),
        unselectedLabelStyle: const TextStyle(fontFamily: "Poppins"),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13,
              color: label == "User" ? Colors.orange : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
