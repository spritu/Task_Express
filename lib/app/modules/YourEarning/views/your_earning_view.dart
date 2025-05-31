import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../provider_home/controllers/provider_home_controller.dart';
import '../controllers/your_earning_controller.dart';

class YourEarningView extends GetView<YourEarningController> {
  const YourEarningView({super.key});
  @override
  Widget build(BuildContext context) {
    final YourEarningController controller = Get.put(YourEarningController());
    final ProviderHomeController providerController = Get.put(
      ProviderHomeController(),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    Text(
                      'Earnings',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(""),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 4, color: Color(0xFFF67C0A)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _earningsCard(
                          title: "This Week",
                          amount:
                              "₹${providerController.dashboardData['weekEarnings'].toString()}",
                        ),
                        _earningsCard(
                          title: "This Month",
                          amount:
                              "₹${providerController.dashboardData['monthEarnings'].toString()}",
                        ),
                        _earningsCard(
                          title: "Total",
                          amount:
                              "₹${providerController.dashboardData['totalEarnings'].toString()}",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Text(
                        "Recent Earnings",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "View all",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: "poppins",
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 25,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Color(0xFFF67C0A),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0xFFF67C0A),
                              ),
                            ],
                          ),
                          child: Icon(Icons.tune, size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Obx(() {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: controller.bookings.length,
                        itemBuilder: (context, index) {
                          final booking = controller.bookings[index];
                          final user = booking['bookedBy'];

                          // Safe fullName
                          final fullName =
                              "${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}";

                          // ✅ Safe address handling (fixes your error!)
                          final rawAddress = user?['address'];
                          final address =
                              rawAddress is String
                                  ? rawAddress
                                  : (rawAddress is List
                                      ? rawAddress.join(', ')
                                      : 'N/A');

                          // Safe charge
                          final charge = booking['pay']?.toString() ?? "0";

                          // Safe date
                          final createdAtString = booking['jobStartTime'] ?? '';
                          String dateFormatted = 'N/A';
                          if (createdAtString.isNotEmpty) {
                            final parsedDate = DateTime.tryParse(
                              createdAtString,
                            );
                            if (parsedDate != null) {
                              dateFormatted =
                                  "${parsedDate.day.toString().padLeft(2, '0')}/"
                                  "${parsedDate.month.toString().padLeft(2, '0')}/"
                                  "${parsedDate.year}";
                            }
                          }

                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name and location
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: fullName + "\n",
                                                style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: address,
                                                style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF595959),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Earn section
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Earn: ₹ ",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFF67C0A),
                                              ),
                                            ),
                                            TextSpan(
                                              text: charge,
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFFF67C0A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "Plumbing service",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF575757),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Date: ",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF575757),
                                              ),
                                            ),
                                            TextSpan(
                                              text: dateFormatted,
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 26,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFFF67C0A),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Details",
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFF67C0A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Divider(thickness: 1),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _earningsCard({required String title, required String amount}) {
    return Expanded(
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 6),
            Container(
              height: 2,
              width: 53,
              color: Color(0xFF7B7B7B),
              margin: EdgeInsets.symmetric(vertical: 4),
            ),
            SizedBox(height: 6),
            Text(
              amount,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFFF67C0A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
