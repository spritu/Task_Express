import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../colors.dart';
import '../../AboutTaskexpress/views/about_taskexpress_view.dart';
import '../../add_address/views/add_address_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../edit_profile/views/edit_profile_view.dart';
import '../../provider_profile/views/provider_profile_view.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0;
        Get.offAll(() => BottomView());
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: AppColors.appGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    const Text(
                      "Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Obx(() {
                                final imagePath = controller.imagePath.value;
                                return CircleAvatar(
                                  radius: 35,
                                  backgroundImage: imagePath.startsWith("http")
                                      ? NetworkImage(imagePath)
                                      : FileImage(File(imagePath)) as ImageProvider,
                                  backgroundColor: Colors.grey[200],
                                );
                              }),



                              // Image.asset("assets/images/account.png"),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        ' ${controller.firstName.value} ${controller.lastName.value}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                    Obx(() {
                                      return Text(
                                        controller.mobileNumber.isEmpty
                                            ? "Mobile number not found"
                                            : "+91 ${controller.mobileNumber.value}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(EditProfileView());
                                },
                                child: Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        // height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/service_provider.png",
                                color: AppColors.orage,
                                height: 16,
                                width: 16,
                              ),
                              SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 5,
                                ),
                                child: Text(
                                  'Join as a Service provider',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.orage,
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(ProviderProfileView());
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.orage,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            buildList(
                              context,
                              Icons.view_list_outlined,
                              "My plans",
                              Icons.arrow_forward_ios,
                            ),
                            Divider(thickness: 1),
                            buildList(
                              context,
                              Icons.account_balance_wallet_outlined,
                              "Wallet",
                              Icons.arrow_forward_ios,
                            ),
                            Divider(thickness: 1),
                            InkWell(
                              onTap: () {
                                Get.to(AddAddressView());
                              },
                              child: buildList(
                                context,
                                Icons.location_on_outlined,
                                "Manage addresses",
                                Icons.arrow_forward_ios,
                              ),
                            ),
                            Divider(thickness: 1),
                            buildList(
                              context,
                              Icons.attach_money_outlined,
                              "Manage payment options",
                              Icons.arrow_forward_ios,
                            ),
                            Divider(thickness: 1),
                            InkWell(
                              onTap: () {
                                Get.to(AboutTaskexpressView());
                              },
                              child: buildList(
                                context,
                                Icons.info_outline,
                                "About ",
                                Icons.arrow_forward_ios,
                                richText: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Task',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    TextSpan(
                                      text: 'Express',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(thickness: 1),
                            buildList(
                              context,
                              Icons.delete,
                              // still required but ignored if image is passed
                              "Delete Account",
                              Icons.arrow_forward_ios,
                              textColor: Color(0xffFB4621),
                              leadingImagePath: 'assets/images/delete.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    InkWell(onTap: (){
                      controller. logout();
                    },
                      child: Container(
                        height: 28,
                        width: 75,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w500,
                            color: Color(0xff114BCA)),
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
      ),
    );
  }
}

Widget buildList(
  BuildContext context,
  IconData leadingIcon,
  String name,
  IconData trailingIcon, {
  TextSpan? richText,
  Color textColor = Colors.black,
  String? leadingImagePath, // 👈 for image instead of icon
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
    child: Row(
      children: [
        leadingImagePath != null
            ? Image.asset(
              leadingImagePath,
              width: 20,
              height: 20,
              color: Colors.black87, // optional: match icon color
            )
            : Icon(leadingIcon, color: Colors.black87, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child:
              richText != null
                  ? RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        color: textColor,
                      ),
                      children: [TextSpan(text: name), richText],
                    ),
                  )
                  : Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Poppins",
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
        ),
        Icon(trailingIcon, size: 16, color: Colors.black54),
      ],
    ),
  );
}
