import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../colors.dart';
import '../../AboutTaskexpress/views/about_taskexpress_view.dart';
import '../../add_address/views/add_address_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../edit_profile/controllers/edit_profile_controller.dart';
import '../../edit_profile/views/edit_profile_view.dart';
import '../../provider_editProfile/controllers/provider_edit_profile_controller.dart';
import '../../provider_profile/views/provider_profile_view.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());  Get.put(EditProfileController());Get.put(ProviderEditProfileController());
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
                    InkWell(onTap: (){
                      Get.to(EditProfileView());
                    },
                      child: Card(
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
                                // Obx(() {
                                //   final imageUrl = controller.imagePath.value;
                                //   return CircleAvatar(
                                //     radius: 40,
                                //     backgroundImage: imageUrl.isNotEmpty
                                //         ? NetworkImage(imageUrl)
                                //         : const AssetImage('assets/images/account.png') as ImageProvider,
                                //     onBackgroundImageError: (_, __) {
                                //       print("❌ Image failed to load.");
                                //     },
                                //   );
                                // }),

                                Obx(() {
                          final controller = Get.find<ProviderEditProfileController>();
                          final localImagePath = controller.selectedImagePath.value;
                          final serverImageUrl = controller.imagePath.value;

                          ImageProvider imageProvider;

                          if (localImagePath.isNotEmpty && File(localImagePath).existsSync()) {
                          imageProvider = FileImage(File(localImagePath));
                          } else if (serverImageUrl.isNotEmpty) {
                          imageProvider = NetworkImage(serverImageUrl);
                          } else {
                          imageProvider = const AssetImage('assets/images/account.png');
                          }

                          return CircleAvatar(
                          radius: 40,
                          backgroundImage: imageProvider,
                          );
                          }),



                          Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        String capitalize(String s) =>
                                            s.isNotEmpty ? s[0].toUpperCase() + s.substring(1).toLowerCase() : '';

                                        final firstName = capitalize(controller.firstName.value);
                                        final lastName = capitalize(controller.lastName.value);

                                        return Text(
                                          '$firstName $lastName',
                                          style: const TextStyle(
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
                    ),
                    SizedBox(height: 20),
                    InkWell(
    onTap: () async {
      final prefs =
      await SharedPreferences.getInstance();
      final userId =
          prefs.getString('user_id') ?? '';

      Get.to(
            () => ProviderProfileView(),
        arguments: {'userId': userId},
      );
    },
                      child: Card(
                        child: Container(
                          // height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/service_provider.png",
                                  color: AppColors.orage,
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 3,
                                  ),
                                  child: Text(
                                    'Join as a Service provider',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      height: 20 / 13, // line-height = 20px
                                      letterSpacing: 0.06 * 13, // 6% of font-size = 0.78
                                      color: AppColors.orage,
                                    ),
                                  ),

                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    final prefs =
                                    await SharedPreferences.getInstance();
                                    final userId =
                                        prefs.getString('user_id') ?? '';

                                    Get.to(
                                          () => ProviderProfileView(),
                                      arguments: {'userId': userId},
                                    );
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
                    ),
                    SizedBox(height: 20),
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
                            ), Divider(thickness: 1),
                            InkWell(
                              onTap: () {
                                Get.to(AddAddressView());
                              },
                              child: buildList(
                                context,
                                Icons.sign_language,
                                "Language",
                                Icons.arrow_forward_ios,
                              ),
                            ),
                            Divider(thickness: 1),
                            InkWell(
                              onTap: () {
                                Get.to(AddAddressView());
                              },
                              child: buildList(
                                context,
                                Icons.privacy_tip_outlined,
                                "Privacy & Data",
                                Icons.arrow_forward_ios,
                              ),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    InkWell(
                      onTap: () {
                        controller.logout();
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
                              color: Color(0xff114BCA),
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