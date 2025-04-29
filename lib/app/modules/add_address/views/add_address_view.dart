import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../AddressScreen/views/address_screen_view.dart';
import '../controllers/add_address_controller.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Color(0xFF87AAF6), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Manage Address",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 24), // Empty space
                ],
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Get.to(AddressScreenView());
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.blue),
                        Text(
                          "Add another address",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.addressList.isEmpty) {
                    return Center(child: Text("No addresses found"));
                  }
                  return ListView.builder(
                    itemCount: controller.addressList.length,
                    itemBuilder: (context, index) {
                      var address = controller.addressList[index];
                      String houseNo = address['houseNo'] ?? 'No house no';
                      String landMark = address['landMark'] ?? 'No landmark';
                      String addressType = address['addressType'] ?? 'Home';
                      String contactNo = address['contactNo'] ?? 'No contact';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      addressType,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "poppins",
                                        color: Color(0xff464646),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      houseNo,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                        color: Color(0xff464646),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      landMark,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                        color: Color(0xff464646),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      contactNo,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                        color: Color(0xff464646),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Image.asset("assets/images/delete.png", color: AppColors.blue),
                                onPressed: () {
                                  String addressId = address['_id']; // ✅ Correct field
                                  controller.deleteAddress(addressId); // ✅ Direct pass id
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
