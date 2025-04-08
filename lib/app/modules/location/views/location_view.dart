import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../bottom/views/bottom_view.dart';
import '../../join/views/join_view.dart';
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 27,
                        width: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF595959),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            Text(
                              "Back",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                fontFamily: "poppins",
                                color: Color(0xFF746E6E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(JoinView());
                      },
                      child: Container(
                        height: 27,
                        width: 51,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF595959),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: "poppins",
                              color: Color(0xFF746E6E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
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
                  "assets/images/Address.png",
                  height: 308,
                  width: 308,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF235CD7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.to(BottomView());
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Choose another Location",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: "poppins",
                      color: Colors.blue,
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
