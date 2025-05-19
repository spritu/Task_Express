import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../../HelpSupport/views/help_support_view.dart';
import '../../job_detail/views/job_detail_view.dart';
import '../../jobsDetails/views/jobs_details_view.dart';
import '../controllers/jobs_controller.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<Bottom2Controller>().selectedIndex.value = 0;
        Get.offAll(() => Bottom2View());
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF5ED), // light background

        body: Container(
          decoration: BoxDecoration(gradient: AppColors.appGradient2),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Jobs',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var bookingList = controller.bookingDataList;

                    if (bookingList.isEmpty) {
                      return const Center(child: Text("No current booking"));
                    }

                    return ListView.builder(
                      itemCount: bookingList.length,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final booking = bookingList[index];

                        final bookedBy = booking['bookedBy'] ?? {};
                        final firstName =
                            bookedBy['firstName']?.toString() ?? 'Unknown';
                        final lastName = bookedBy['lastName']?.toString() ?? '';
                        final city = bookedBy['city']?.toString() ?? 'No city';

                        final bookServices = booking['bookServices'] ?? [];
                        final serviceName =
                            bookServices.isNotEmpty
                                ? bookServices[0]['name']?.toString() ??
                                    'Service'
                                : 'Service';

                        final earning = booking['earning']?.toString() ?? '0';
                        final duration =
                            booking['duration']?.toString() ?? '--';
                        print('Booking index: $index');
                        print('First name: $firstName');
                        print('Last name: $lastName');

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFCC9E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current Job",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 6),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "$firstName $lastName",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Poppins",
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 18,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        city,
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 22,
                                                  ),
                                                  child: Text(
                                                    '3.5 km, 28 min to reach',
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12,
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.assignment_turned_in,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      serviceName,
                                                      style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Price/Time Button
                                          // priceTimeButton(
                                          //   price: "₹$earning",
                                          //   duration: "$duration Hrs",
                                          //   isSelected: true,
                                          //   onTap: () {},
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: _outlinedButton("Call", false),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: Get.context!,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder:
                                                      (_) => Container(
                                                        decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                      16,
                                                                    ),
                                                                topRight:
                                                                    Radius.circular(
                                                                      16,
                                                                    ),
                                                              ),
                                                        ),
                                                        child:
                                                            const JobDetailView(),
                                                      ),
                                                );
                                              },
                                              child: _outlinedButton(
                                                "Details",
                                                false,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(() => HelpSupportView());
                                              },
                                              child: _outlinedButton(
                                                "Help",
                                                true,
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
                    );
                  }),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Past Jobs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 12),
                _buildPastJob(
                  name: 'Sourabh m..',
                  location: 'Saket Nagar, Indore',
                  amount: '450',
                  date: '12/12/2024',
                  status: 'Job Done',
                  statusColor: Colors.green,
                  icon: Icons.check_circle,
                ),
                _buildPastJob(
                  name: 'Aneesha Sin..',
                  location: 'Old Palasia, Indore',
                  amount: '700',
                  date: '11/12/2024',
                  status: 'Job Done',
                  statusColor: Colors.green,
                  icon: Icons.check_circle,
                ),
                _buildPastJob(
                  name: 'Smita patd..',
                  location: 'Rau square, Indore',
                  amount: '700',
                  date: '11/12/2024',
                  status: 'Reject',
                  statusColor: Colors.grey,
                  icon: Icons.cancel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentJobCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var bookingList = controller.bookingDataList;

        if (bookingList.isEmpty) {
          return const Center(child: Text("No current booking"));
        }

        return ListView.builder(
          itemCount: bookingList.length,
          itemBuilder: (context, index) {
            final booking = bookingList[index];

            final bookedBy = booking['bookedBy'] ?? {};
            final firstName = bookedBy['firstName']?.toString() ?? 'Unknown';
            final lastName = bookedBy['lastName']?.toString() ?? '';
            final city = bookedBy['city']?.toString() ?? 'No city';

            final bookServices = booking['bookServices'] ?? [];
            final serviceName =
                bookServices.isNotEmpty
                    ? bookServices[0]['name']?.toString() ?? 'Service'
                    : 'Service';

            final earning = booking['earning']?.toString() ?? '0';
            final duration = booking['duration']?.toString() ?? '--';
            print('Booking index: $index');
            print('First name: $firstName');
            print('Last name: $lastName');

            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFFCC9E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Job",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "$firstName $lastName",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Poppins",
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'E7, 775, Saket Nagar, Indore',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(left: 22),
                                    child: Text(
                                      '3.5 km, 28 min to reach',
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 12,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assignment_turned_in,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Basic Plumbing work',
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Price/Time Button
                            priceTimeButton(
                              price: "₹250",
                              duration: "3 hrs",
                              isSelected: true,
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: _outlinedButton("Call", false)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: Get.context!,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder:
                                        (_) => Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: const JobDetailView(),
                                        ),
                                  );
                                },
                                child: _outlinedButton("Details", false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => HelpSupportView());
                                },
                                child: _outlinedButton("Help", true),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget priceTimeButton({
    required String price,
    required String duration,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "for",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              duration,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String title, Color bg, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: borderColor,
          fontFamily: "poppins",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _filledButton(String title, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontFamily: "poppins",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _outlinedButton(String title, bool isSelected) {
    return SizedBox(
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPastJob({
    required String name,
    required String location,
    required String amount,
    required String date,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Icon(icon, size: 16, color: statusColor),
                const SizedBox(width: 4),
                Text(status, style: TextStyle(color: statusColor)),
              ],
            ),
          ],
        ),
        Text(location, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        const Text("Plumbing service", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          "Earn: ₹ $amount",
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date: $date",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            InkWell(
              onTap: () {
                Get.to(JobsDetailsView());
              },
              child: _actionButton("Details", Colors.white, Colors.orange),
            ),
          ],
        ),
      ],
    );
  }
}
