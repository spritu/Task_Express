import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../add_address/views/add_address_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../bottom/views/bottom_view.dart';
import '../../edit_profile/views/edit_profile_view.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<BottomController>().selectedIndex.value = 0; // 👈 Home tab
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
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset("assets/images/account.png"),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Akash Gupta",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "+91 8784789040",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "poppins",
                                        fontSize: 12,
                                        color: Color(0xFF746E6E),
                                      ),
                                    ),
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
                            buildList(
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
                          ],
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
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
    child: Row(
      children: [
        Icon(leadingIcon, color: Colors.black87, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child:
              richText != null
                  ? RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                      children: [TextSpan(text: name), richText],
                    ),
                  )
                  : Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      color: Colors.black,
                    ),
                  ),
        ),
        Icon(trailingIcon, size: 16, color: Colors.black54),
      ],
    ),
  );
}
