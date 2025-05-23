import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../colors.dart';
import '../controllers/activejob_screen_controller.dart';

class ActivejobScreenView extends GetView<ActivejobScreenController> {
  const ActivejobScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 30),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scheme No 54',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              // color: AppColors.textColor,
                            ),
                          ),
                          Text(
                            'Fh-289, Vijayanagar,Indore',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              // color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 30, // You can adjust size
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.notifications,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 95,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Color(0x69B2B2B2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Available Switch Column
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 46,
                              width: 154,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Available",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  Obx(
                                        () => FlutterSwitch(
                                      width: 53.0,
                                      height: 26.18,
                                      toggleSize: 23.0,
                                      value: controller.isAvailable2.value,
                                      borderRadius: 20.0,
                                      activeColor: Colors.green,
                                      inactiveColor: Colors.grey.shade400,
                                      toggleColor: Colors.white,
                                      padding: 1.0,
                                      onToggle: (val) {
                                        controller.isAvailable2.value = val;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Available or Not available",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: "Poppins",
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 2),
                        // Service Profile Switch Column
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 46,
                              width: 154,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Service\n Profile",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Poppins",
                                    ),
                                  ),

                                  Obx(
                                        () => FlutterSwitch(
                                      width: 53.0,
                                      height: 26.18,
                                      toggleSize: 23.0,
                                      value: controller.isServiceProfile.value,
                                      borderRadius: 20.0,
                                      activeColor: Colors.orange,
                                      inactiveColor: Colors.grey.shade400,
                                      padding: 1.0,
                                      onToggle: (val) {
                                        controller.isServiceProfile.value = val;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Service profile or User profile",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: "Poppins",
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 54,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFFCD8B7),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Hello Suraj,",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: "Poppins",
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            children: [
                              const TextSpan(text: "You’re "),
                              const TextSpan(
                                text: "Online",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    "Job assigned, be there in time!",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "poppins",
                      color: Color(0xFFF67C0A),
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.5,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFFFCD8B7),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height:MediaQuery.of(context).size.height*0.2,
                            child: GetBuilder<ActivejobScreenController>(
                              builder: (controller) {
                                if (controller.currentLatLng == null) {
                                  return const Expanded(
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }

                                return StreamBuilder<Object>(
                                  stream: null,
                                  builder: (context, snapshot) {
                                    return SizedBox(
                                     // height: 250,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                          target: controller.currentLatLng ?? controller.defaultLatLng,
                                          zoom: 14,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId("currentLocation"),
                                            position: controller.currentLatLng ?? controller.defaultLatLng,
                                          ),
                                        },
                                        onMapCreated: (GoogleMapController mapController) {
                                          if (!controller.mapControllerCompleter.isCompleted) {
                                            controller.mapControllerCompleter.complete(mapController);
                                          }
                                        },
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 3),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: Container(
                              height: 169,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Row: Left Side (Details) + Right Side (Earning & Duration)
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Left Side Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                Text(
                                                  "Shivani singh,",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: const [
                                                Expanded(
                                                  child: Text(
                                                    "E7, 775, saket nagar Indore",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Landmark: Beside pizza hut",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Color(0xFF616161),
                                              ),
                                            ),

                                            const SizedBox(height: 8),
                                            const Row(
                                              children: [
                                                Text(
                                                  "Assigned for: Basic Plumbing work",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Color(0xFF7A7A7A),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Right Side Column (Earning + Duration)
                                      Column(
                                        children: [
                                          _infoCard(
                                            title: "Distance",
                                            value: "3.5 km",
                                          ),
                                          const SizedBox(height: 8),
                                          _infoCard(
                                            title: "Duration",
                                            value: "28 mins",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Action Buttons
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      _actionButton(
                                        "Reject",
                                        Colors.white,
                                        Color(0xFFF67C0A),
                                        textColor: const  Color(0xFFF67C0A),
                                      ),
                                      _actionButton(
                                        "Call",
                                        Color(0xFFF67C0A),
                                        Colors.white,
                                      ),  _actionButton(
                                        "Navigation",
                                        Color(0xFFF67C0A),
                                        Colors.white,
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

                  SizedBox(height: 10),
                  Text(
                    "Today’s Dashboard",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "poppins",
                      color: Color(0xFFF67C0A),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _dashboardCard(
                              title: "Today's\n Jobs",
                              value: "2",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dashboardCard(
                              title: "Earnings\n Today",
                              value: "₹750",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _dashboardCard(
                              title: " Hour’s\nWorked",
                              value: "5",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dashboardCard(
                              title: "Average\n Rating",
                              value: "4.7",
                              icon: Icons.star,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Earnings",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFFF67C0A),
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _earningsCard(title: "This Week", amount: "₹2450"),
                        _earningsCard(title: "This Month", amount: "₹8450"),
                        _earningsCard(title: "Total", amount: "₹34,450"),
                      ],
                    ),
                  ),
                  Text(
                    "Recent Jobs",
                    style: TextStyle(
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFFF67C0A),
                    ),
                  ),
                  SizedBox(height: 5),

                  // Card List Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView.builder(shrinkWrap: true,
                      itemCount: 5, // or your dynamic length
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _jobItem(),
                            if (index != 4)
                              Divider(color: Colors.grey.shade300, height: 1),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Round orange border button (no icon inside per image)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 28,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFF67C0A),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "View More", // or any text you want
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF67C0A),
                          ),
                        ),
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

  Widget _earningsCard({required String title, required String amount}) {
    return Expanded(
      child: Container(
        height: 119,
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(vertical: 12),

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
            SizedBox(height: 4),
            Container(
              height: 2,
              width: 53,
              color: Colors.grey.shade300,
              margin: EdgeInsets.symmetric(vertical: 4),
            ),
            Text(
              amount,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFFE66800),
              ),
            ),
            SizedBox(height: 15),
            // Details button
            Container(
              height: 24,
              width: 54,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF67C0A)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 10,
                    color: Color(0xFFE66800),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // Job details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Plumbing job",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Pipe Repair",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    color: Color(0xFFF67C0A),
                  ),
                ),
              ],
            ),
          ),

          // Amount
          const Text(
            "₹8450",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color: Color(0xFFF67C0A),
            ),
          ),

          const SizedBox(width: 20),

          // Date
          const Text(
            "10 Apr 2025",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoCard({required String title, required String value}) {
  return Container(
    height: 43,
    width: 82,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: "Poppins",
          ),
        ),
      ],
    ),
  );
}

Widget _actionButton(
    String text,
    Color bgColor,
    Color borderColor, {
      Color? textColor,
    }) {
  return Container(
    height: 30,
    width: 90,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor),
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: textColor ?? Colors.white,
      ),
    ),
  );
}

Widget _dashboardCard({
  required String title,
  required String value,
  Color valueColor = const Color(0xFFF67C0A),
  IconData? icon,
}) {
  return Container(
    height: 56,
    width: 162,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Colors.black,
            ),
          ),
        ),

        // Divider
        Container(
          height: 24,
          width: 1,
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(horizontal: 10),
        ),

        // Value (with optional icon)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 16, color: Colors.amber),
            if (icon != null) const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}