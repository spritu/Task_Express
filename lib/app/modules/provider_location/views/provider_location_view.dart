import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../../bottom/views/bottom_view.dart';
import '../../provider_home/views/provider_home_view.dart';
import '../../provider_profile/views/provider_profile_view.dart';
import '../controllers/provider_location_controller.dart';

class ProviderLocationView extends GetView<ProviderLocationController> {
  const ProviderLocationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: BoxDecoration(gradient: AppColors.appGradient2),
        height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                SizedBox(height: 20),
                Text(
                  "Hey there! How’s it going today?",
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
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
                SizedBox(height: 20,),
                Image.asset(
                  "assets/images/provide_loca.png",
                  height: 308,
                  width: 308,
                ),
                SizedBox(height: 20,),
                SizedBox(height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orage,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.to(Bottom2View());
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
                SizedBox(height: 20,),
                Text(
                  "or",
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF939393),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.to(Bottom2View());
                    },
                    child: Text(
                      "Choose another Location",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: "poppins",
                        color: AppColors.orage,
                      ),
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
