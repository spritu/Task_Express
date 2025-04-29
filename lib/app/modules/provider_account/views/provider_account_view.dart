import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../../YourEarning/views/your_earning_view.dart';
import '../../provider_editProfile/views/provider_edit_profile_view.dart';
import '../controllers/provider_account_controller.dart';

class ProviderAccountView extends GetView<ProviderAccountController> {
  const ProviderAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
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

                  /// Profile Card
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
                            CircleAvatar(
                              radius: 40,
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/rajesh.png",
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
                              Get.to(ProviderEditProfileView());
                              },
                              child: Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          _buildRow("Profession", "Fixed Charge Helper", isDropdown: true),
                          Divider(thickness: 1),
                          _buildRow("Category", "Construction & Masonary", isDropdown: true),
                          Divider(thickness: 1),
                          _buildRow("Sub Category", "Bricklaying Helper", isDropdown: true),
                          Divider(thickness: 1),
                          _buildRow("Charge", "₹ 250", isEditable: true),
                        ],
                      ),
                    ),
                  ),SizedBox(height: 20,),
                  /// Toggleable Service Card
                  Obx(() => controller.showServiceCard.value
                      ? Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Obx(() => _buildRow1(
                      context,
                      "Profession",
                      controller.selectedProfession.value,
                      isDropdown: true,
                      options: ["Visiting Professional", "Fixed Charge Helper"],
                      onOptionSelected: (value) => controller.setProfession(value),
                    )
                          ),Divider(thickness: 1),Obx(() => _buildRow1(
                    context,
                    "Category",
                    controller.selectCategory.value,
                    isDropdown: true,
                    options: ["Construction & Masonry", "Electrical and Plumbing", "Household & Cleaning","Transport & Loading","Mechanic & Garage",
                    "Office & Business","Event & Function","Pet care & Animal","Specialty Construction","Home Improvement","Farming & Agriculture"],
                    onOptionSelected: (value) => controller.setCategory(value),
                  )),Divider(thickness: 1),Obx(() => _buildRow1(
                    context,
                    "Sub Category",
                    controller.selectSubCategory.value,
                    isDropdown: true,
                    options: ["Bricklaying Helper", "Cement Mixing Helper", "Scaffolding Helper","Tile Fixing Helper","Road Construction Helper",
                      "Plastering Helper"],
                    onOptionSelected: (value) => controller.selectSubCategory(value),
                  )),Divider(thickness: 1),Obx(() => _buildRow1(
                            context,
                            "Charge",
                           controller.selectCharge.value,
                            isEditable: true,
                            onOptionSelected: (value) => controller.setCharge(value),
                          ))

                        ],
                      ),
                    ),
                  )
                      : SizedBox.shrink()),

                  SizedBox(height: 10),

                  /// Add Service Button
                  InkWell(
                    onTap: () {
                      controller.toggleServiceCard();
                    },
                    child: Container(
                      height: 34,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 18),
                          SizedBox(width: 5),
                          Text(
                            "Add Service",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  /// Other options card
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
                          InkWell(onTap: (){
                            Get.to(YourEarningView());
                          },
                              child: buildList(context, Icons.money, "Your Earnings", Icons.arrow_forward_ios)),
                          Divider(thickness: 1),
                          buildList(context, Icons.location_on_outlined, "Manage addresses", Icons.arrow_forward_ios),
                          Divider(thickness: 1),
                          buildList(context, Icons.monetization_on_outlined, "Manage payment options", Icons.arrow_forward_ios),
                          Divider(thickness: 1),
                          buildList(
                            context,
                            Icons.info_outline,
                            "About ",
                            Icons.arrow_forward_ios,
                            richText: const TextSpan(
                              children: [
                                TextSpan(text: 'Task', style: TextStyle(color: Colors.blue)),
                                TextSpan(text: 'Express', style: TextStyle(color: Colors.orange)),
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
    );
  }
}

Widget _buildRow(
  String title,
  String value, {
  bool isDropdown = false,
  bool isEditable = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.textColor,
            fontFamily: "poppins",
          ),
        ),
        Row(
          children: [
            Text(
          value,
              style: TextStyle(
                color: AppColors.orage,
                fontSize: 13,
                fontFamily: "poppins",
                fontWeight: FontWeight.w500,
              ),
            ),SizedBox(width: 5),
            if (isDropdown)
              Icon(Icons.keyboard_arrow_down, color: Colors.black54),
            if (isEditable)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.edit, size: 18),
              ),
          ],
        ),
      ],
    ),
  );
}
Widget _buildRow1(
    BuildContext context,
    String title,
    String value, {
      bool isDropdown = false,
      bool isEditable = false,
      List<String> options = const [],
      required Function(String) onOptionSelected,
    }) {
  final TextEditingController textController = TextEditingController(text: value);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
            fontFamily: "poppins",
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 13,
                fontFamily: "poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            if (isDropdown)
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              "Choose $title",
                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                            const Divider(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: options.map((option) {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Center(
                                            child: Text(option, style: const TextStyle(color: Colors.orange)),
                                          ),
                                          onTap: () {
                                            onOptionSelected(option);
                                            Get.back();
                                          },
                                        ),
                                        const Divider(),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ),
            if (isEditable)
              InkWell(
                onTap: () async {
                  final result = await showDialog<String>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Edit $title"),
                        content: TextField(
                          controller: textController,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, textController.text),
                            child: const Text("Save"),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null && result.trim().isNotEmpty) {
                    onOptionSelected(result.trim());
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.edit, size: 18),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}



Widget _buildRow2(BuildContext context, String title) {
  final controller = Get.find<ProviderAccountController>();

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        Obx(() => Row(
          children: [
            Text(
              controller.selectedProfession.value,
              style: TextStyle(
                color: controller.selectedProfession.value != "Fixed Charge Helper"
                    ? Colors.orange
                    : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          "Choose Your Profession",
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Center(
                            child: Text("Visiting Professional", style: TextStyle(color: Colors.orange)),
                          ),
                          onTap: () {
                            controller.setProfession("Visiting Professional");
                            Get.back();
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Center(
                            child: Text("Fixed Charge Helper", style: TextStyle(color: Colors.orange)),
                          ),
                          onTap: () {
                            controller.setProfession("Fixed Charge Helper");
                            Get.back();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
            ),
          ],
        )),
      ],
    ),
  );
}


Widget buildList(
  BuildContext context,
  IconData leadingIcon,
  String name,
  IconData trailingIcon, {
  TextSpan? richText,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
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
