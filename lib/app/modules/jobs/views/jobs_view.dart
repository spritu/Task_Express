import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../../HelpSupport/views/help_support_view.dart';
import '../../booking/controllers/booking_controller.dart';
import '../../job_detail/views/job_detail_view.dart';
import '../../jobsDetails/views/jobs_details_view.dart';
import '../../provider_home/controllers/provider_home_controller.dart';
import '../controllers/jobs_controller.dart';

class JobsView extends GetView<JobsController> {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(JobsController());
    return WillPopScope(
      onWillPop: () async {
        Get.find<Bottom2Controller>().selectedIndex.value = 0;
        Get.offAll(() => Bottom2View());
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF5ED),
        appBar: AppBar(
          title: Text(
            'Jobs',
            style: TextStyle(
              color: Colors.black,
              fontFamily: "poppins",
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFF89E4A),
        ),

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
                    children: [],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      Icons
                                                          .assignment_turned_in,
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
                                            child: _outlinedButton(
                                              "Call",
                                              false,
                                            ),
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
                Obx(() {
                  final ProviderHomeController proController =
                      Get.find<ProviderHomeController>();
                  print(
                    'pastBookings length: ${proController.pastBookings.length}',
                  );
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: proController.pastBookings.length,
                    itemBuilder: (context, index) {
                      final job = proController.pastBookings[index];
                      print('jobssss:$job');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        print('jobssss: $job');
                      });

                      // Extract service name
                      final fullName =
                          "${job['bookedBy']['firstName']} ${job['bookedBy']['lastName']}";

                      // Extract amount
                      final amount = job['pay']?.toString() ?? '0';
                      final servicejob =
                          (job['bookServices'] != null &&
                                  job['bookServices'] is List &&
                                  job['bookServices'].isNotEmpty)
                              ? job['bookServices'][0]['name'] ??
                                  'Unknown Service'
                              : 'Unknown Service';

                      // Extract and format date
                      final jobStartTime =
                          job['jobStartTime']?.toString() ?? '';
                      final dateOnly =
                          jobStartTime.contains('T')
                              ? jobStartTime.split('T')[0]
                              : jobStartTime;
                      final formattedDate = formatDate(
                        dateOnly,
                      ); // You should define this function.

                      // Extract user location
                      final user = job['bookedBy'] as Map<String, dynamic>?;
                      final location = user?['city']?.toString() ?? 'Unknown';

                      // Static status info
                      const status = "Completed";
                      const statusColor = Colors.green;
                      const icon = Icons.check_circle;
                      return _buildPastJob(
                        name: fullName,
                        location: location,
                        amount: amount,
                        service: servicejob,
                        date: formattedDate,
                        status: status,
                        statusColor: statusColor,
                        icon: icon,
                      );
                    },
                  );
                }),
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
    required String service,
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
        SizedBox(height: 4),
        Text(service, style: TextStyle(fontSize: 12)),
        SizedBox(height: 4),
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
                // Get.to(JobsDetailsView());
              },
              child: _actionButton("Details", Colors.white, Colors.orange),
            ),
          ],
        ),
      ],
    );
  }
}

void showPaymentBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          gradient: AppColors.appGradient2,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 10),
              Text(
                'Confirm Payment Received',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: 'poppins',
                ),
              ),
              const SizedBox(height: 20),

              Image.asset(
                'assets/images/payment_confirm.png', // replace with your illustration
                height: 246,
                width: 246,
              ),

              const SizedBox(height: 20),
              Text(
                'You’ve received a payment confirmation from the user. Please verify the amount received.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        InfoRow(label: 'User', value: 'Shivani Singh'),
                        InfoRow(label: 'Duration', value: '3 Hours'),
                        InfoRow(label: 'Date', value: '7 April, 2025'),
                        InfoRow(label: 'Time', value: '10:30 AM - 01:30 PM'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                child: Container(
                  height: 44,
                  width: 157,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Amount: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'poppins',
                        ),
                      ),
                      Text(
                        '₹250',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 37,
                    width: 100,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'poppins',
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    height: 37,
                    width: 147,
                    child: ElevatedButton(
                      onPressed: () {
                        // Accept Payment logic here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Accept Payment',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey[700])),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
