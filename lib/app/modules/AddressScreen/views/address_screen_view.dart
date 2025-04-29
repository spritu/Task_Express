import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../colors.dart';
import '../controllers/address_screen_controller.dart';

class AddressScreenView extends StatelessWidget {
  AddressScreenView({super.key});

  final AddressScreenController controller = Get.put(AddressScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      "Add Address",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                    ),Text("   ")
                   // const SizedBox(width: 48), // Placeholder for alignment
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<AddressScreenController>(
                  builder: (controller) {
                    if (controller.currentLatLng == null) {
                      return  SizedBox(
                        height:MediaQuery.of(context).size.height*0.1,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return SizedBox(
                      height:MediaQuery.of(context).size.height*0.3,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: controller.currentLatLng!,
                          zoom: 14,
                        ),
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController mapController) {
                          if (!controller.mapControllerCompleter.isCompleted) {
                            controller.mapControllerCompleter.complete(mapController);
                          }
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("currentLocation"),
                            position: controller.currentLatLng!,
                            infoWindow: const InfoWindow(title: "You are here"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                          ),
                          Marker(
                            markerId: const MarkerId("plumberLocation"),
                            position: controller.plumberLatLng,
                            infoWindow: const InfoWindow(title: "Plumber"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                          ),
                        },
                      ),
                    );
                  },
                ),
              ),


              // Rest of the Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Location",
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Pin the exact location on map to help service provider reach on time",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          fontFamily: "poppins",
                          color: Color(0xFF717171),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Obx(() {
                              return RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    // Display House No
                                    TextSpan(
                                      text: controller.houseNo.value.isNotEmpty
                                          ? '${controller.houseNo.value},\n'
                                          : "Loading house number...\n",
                                    ),
                                    // Display Landmark
                                    TextSpan(
                                      text: controller.landMark.value.isNotEmpty
                                          ? '${controller.landMark.value}\n'
                                          : "Loading landmark...\n",
                                    ),
                                  ],
                                ),
                              );
                            }),

                          ),


                          Container(
                            height: 37,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFC0D1F6)),
                              boxShadow: [BoxShadow(blurRadius: 1.5, color: Color(0xFFC0D1F6))],
                            ),
                            child: const Center(
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "poppins",
                                  color: Color(0xFF114BCA),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(height: 10),
                      _buildInput("House/Flat number", controller.houseController),

                      const SizedBox(height: 10),
                      _buildInput("Landmark (Optional)", controller.landmarkController),

                      const SizedBox(height: 10),
                      const Text(
                        "Save as",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: "poppins",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                            () => Row(
                          children: [
                            _buildChoiceButton("Home"),
                            const SizedBox(width: 8),
                            _buildChoiceButton("Other"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(blurRadius: 2, color: Color(0xFFC0D1F6))],
                        ),
                        child: Row(
                          children:  [
                            Icon(Icons.phone, size: 20, color: Color(0xFF717171)),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(controller: controller.phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText:  "Mobile: +91 9836747398",
                                border: InputBorder.none,),

                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "poppins",
                                  color: Color(0xFF717171),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed:(){
                                controller.showEditDialog(context);
                              }, // Trigger the popup when edit button is pressed
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width: 225,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.saveAddress();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF114BCA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Save address",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String placeholder, TextEditingController controller) {
    return Container(
      height: 37,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFC0D1F6)),
        boxShadow: [BoxShadow(blurRadius: 1.5, color: const Color(0xFFC0D1F6))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 5),
      child: TextField(
        controller: controller, // <-- Controller added here
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontFamily: "poppins",
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: Color(0xFF595959),
          ),
          border: InputBorder.none, // Remove the default border
        ),
      ),
    );
  }




  Widget _buildChoiceButton(String label) {
    final isSelected = controller.selectedAddressType.value == label;

    return GestureDetector(
      onTap: () => controller.selectAddressType(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC0D1F6) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFC0D1F6)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: "poppins",
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
