import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../AddressScreen/views/address_screen_view.dart';
import '../../bottom/views/bottom_view.dart';
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(LocationController());
    return Scaffold(
      body: Container(decoration: BoxDecoration(gradient: AppColors.appGradient),
        height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1),
              Text(
                "Select Location",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 14),
              Text(
                "Hey there! How’s it going today?",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,letterSpacing: 1,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Explore services near you",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                "assets/images/Address.png",
                height: 308,
                width: 276,
              ),
              SizedBox(height: 20),
              SizedBox(height: 54,width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await controller.determinePosition();
                    if (controller.currentAddress.value.isNotEmpty) {
                      Get.to(BottomView());
                    }
                  },

                  child: Text(
                    "Use  your current location",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "or",
                style: TextStyle(
                  fontFamily: "poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Color(0xFF939393),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 54,width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.to(AddressScreenView());
                  },
                  child: Text(
                    "Choose another Location",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins",
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
