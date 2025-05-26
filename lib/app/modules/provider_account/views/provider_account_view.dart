import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../colors.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../../Bottom2/views/bottom2_view.dart';
import '../../YourEarning/views/your_earning_view.dart';
import '../../provider_editProfile/views/provider_edit_profile_view.dart';
import '../controllers/provider_account_controller.dart';

class ProviderAccountView extends GetView<ProviderAccountController> {
  const ProviderAccountView({super.key});

  @override
  Widget build(BuildContext context) {
 Get.put(ProviderAccountController());
    return WillPopScope(
      onWillPop: () async {
        Get.find<Bottom2Controller>().selectedIndex.value = 0;
        Get.offAll(() => Bottom2View());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: AppColors.appGradient2),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                      child: InkWell(onTap: (){
                        Get.to(() => ProviderEditProfileView());
                      },
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
                                Obx(() {
                                  final imageUrl = controller.imagePath.value;
                                  return CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipOval(
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                        imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          print("❌ Image failed to load: $error");
                                          return Image.asset(
                                            'assets/images/account.png',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )
                                          : Image.asset(
                                        'assets/images/account.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        '${controller.firstName.value} ${controller.lastName.value}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 4),
                                    Obx(() {
                                      return Text(
                                        controller.mobileNumber.value.isEmpty
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
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => ProviderEditProfileView());
                                  },
                                  child: Icon(Icons.arrow_forward_ios, size: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(color: Color(0xffFCD8B7),
                        child: Column(
                          children: [Padding(
                            padding: const EdgeInsets.only(top: 5,right: 5),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [Container(height: 21,width: 57,decoration: BoxDecoration(color: Color(0xffF67C0A),
                              borderRadius: BorderRadius.circular(6)),
                              child: InkWell( onTap: () {
                                controller.deleteUserSkill(
                               // make sure userId is available in your controller
                                 "categoryId",
                                "subCategoryId",
                                  1
                                );
                              },
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Image.asset("assets/images/delete.png",height: 12,color: Colors.white,),SizedBox(width: 3,),
                                Text("Delete",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: AppColors.white),)],),
                              ),)],),
                          ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
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
                                      Obx(
                                        () => _buildRow(
                                          "Profession",
                                          controller.selectedProfessionName.value,
                                          isDropdown: false,
                                        ),
                                      ),
                                      Divider(thickness: 1),

                                      Obx(
                                        () => _buildRow(
                                          "Category",
                                          controller.selectedCategoryName.value,
                                          isDropdown: false,
                                        ),
                                      ),
                                      Divider(thickness: 1),
                                      Obx(
                                        () => _buildRow(
                                          "Sub Category",
                                          controller.selectedSubCategoryName.value,
                                          isDropdown: false,
                                        ),
                                      ),
                                      Divider(thickness: 1),
                                      Obx(
                                            () => _buildRow(
                                          "Charge",
                                          controller.charge.value,
                                          isEditable: true,
                                          onEditTap: () {
                                            _showEditPopup(context, "Charge", controller.charge.value, (newVal) {
                                              controller.charge.value = newVal;
                                            });
                                          },
                                        ),
                                      ),],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20),
                    /// Toggleable Service Card
                    Obx(() {
                      return Column(
                        children: controller.serviceCards.asMap().entries.map((entry) {
                          int index = entry.key;
                          ServiceModel model = entry.value;

                          final selectedProfession = model.profession;
                          final categories = selectedProfession == "Visiting Professional"
                              ? controller.visitingProfessionals
                              : controller.fixedChargeHelpers;

                          final selectedCategory = categories.firstWhereOrNull(
                                (cat) => cat.label == model.category,
                          );

                          final subcategories = selectedCategory?.subcategories ?? [];

                          return Card(
                            color: const Color(0xffFCD8B7),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                      onTap: () async {
                          final selectedCat = categories.firstWhereOrNull((cat) => cat.label == model.category);
                          final selectedSub = selectedCat?.subcategories.firstWhereOrNull((sub) => sub.name == model.subcategory);
                          final userId = controller.userId.value;

                          if (selectedCat != null && selectedSub != null && userId.isNotEmpty) {
                          try {
                          var headers = {'Content-Type': 'application/json'};
                          var request = http.Request(
                          'POST',
                          Uri.parse('https://jdapi.youthadda.co/user/deleteuserskill'),
                          );

                          request.body = json.encode({
                          "userId": userId,
                          "categoryId": selectedCat.id,
                          "sucategoryId": selectedSub.id,
                          });

                          request.headers.addAll(headers);
                          http.StreamedResponse response = await request.send();

                          if (response.statusCode == 200) {
                          // Remove from UI after successful delete
                          controller.serviceCards.removeAt(index);
                          controller.serviceCards.refresh();
                          print(await response.stream.bytesToString());
                          } else {
                          print("Delete failed: ${response.reasonPhrase}");
                          Get.snackbar("Error", "Skill delete failed: ${response.reasonPhrase}");
                          }
                          } catch (e) {
                          print("Delete error: $e");
                          Get.snackbar("Error", "Something went wrong while deleting skill.");
                          }
                          } else {
                          Get.snackbar("Error", "Invalid category or subcategory data.");
                          }
                          },

                            child: Container(
                                          height: 21,
                                          width: 57,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF67C0A),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset("assets/images/delete.png", height: 12, color: Colors.white),
                                              const SizedBox(width: 3),
                                              const Text("Delete", style: TextStyle(fontSize: 10, color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          // Profession Dropdown
                                          _buildRow1(
                                            context,
                                            "Profession",
                                            model.profession,
                                            isDropdown: true,
                                            options: ["Visiting Professional", "Fixed Charge Helper"],
                                            onOptionSelected: (value) {
                                              model.profession = value;
                                              model.category = '';
                                              model.subcategory = '';
                                              controller.serviceCards.refresh();
                                            },
                                          ),

                                          const Divider(thickness: 1),

                                          // Category Dropdown
                                          _buildRow1(
                                            context,
                                            "Category",
                                            model.category,
                                            isDropdown: true,
                                            options: categories.map((cat) => cat.label).toList(),
                                            onOptionSelected: (value) async {
                                              model.category = value;
                                              model.subcategory = '';
                                              controller.serviceCards.refresh();

                                              final selectedCat = categories.firstWhereOrNull((c) => c.label == value);
                                              if (selectedCat != null && selectedCat.subcategories.isNotEmpty) {
                                                await controller.updateSkill(
                                                  userId: controller.userId.value,
                                                  categoryId: selectedCat.id ?? '',
                                                  subcategoryId: selectedCat.subcategories.first.id ?? '',
                                                  charge: model.charge,
                                                );
                                              }
                                            },
                                          ),

                                          const Divider(thickness: 1),

                                          // Subcategory Dropdown
                                          _buildRow1(
                                            context,
                                            "Sub Category",
                                            model.subcategory,
                                            isDropdown: true,
                                            options: subcategories.map((sub) => sub.name).toList(),
                                            onOptionSelected: (value) async {
                                              model.subcategory = value;
                                              controller.serviceCards.refresh();

                                              final selectedSub = subcategories.firstWhereOrNull((s) => s.name == value);
                                              final selectedCat = categories.firstWhereOrNull((c) => c.label == model.category);
                                              if (selectedCat != null && selectedSub != null) {
                                                await controller.updateSkill(
                                                  userId: controller.userId.value,
                                                  categoryId: selectedCat.id ?? '',
                                                  subcategoryId: selectedSub.id ?? '',
                                                  charge: model.charge,
                                                );
                                              }
                                            },
                                          ),

                                          const Divider(thickness: 1),

                                          // Charge Input
                                          _buildRow1(
                                            context,
                                            "Charge",
                                            model.charge,
                                            isEditable: true,
                                            onOptionSelected: (value) async {
                                              model.charge = value;
                                              controller.serviceCards.refresh();

                                              final selectedSub = subcategories.firstWhereOrNull((s) => s.name == model.subcategory);
                                              final selectedCat = categories.firstWhereOrNull((c) => c.label == model.category);
                                              if (selectedCat != null && selectedSub != null) {
                                                await controller.updateSkill(
                                                  userId: controller.userId.value,
                                                  categoryId: selectedCat.id ?? '',
                                                  subcategoryId: selectedSub.id ?? '',
                                                  charge: value,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),




                    SizedBox(height: 10),

                    /// Add Service Button
                    InkWell(
                      onTap: () {
                        controller.addServiceCard();
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
                            InkWell(
                              onTap: () {
                                Get.to(YourEarningView());
                              },
                              child: buildList(
                                context,
                                Icons.money,
                                "Your Earnings",
                                Icons.arrow_forward_ios,
                              ),
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
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        controller.logout();
                      },
                      child: Container(
                        height: 28,
                        width: 75,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.orage),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w500,
                              color: AppColors.orage,
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
void _showEditPopup(
    BuildContext context,
    String title,
    String currentValue,
    Function(String) onSave,
    ) {
  final TextEditingController textController =
  TextEditingController(text: currentValue);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Edit $title"),
      content: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: "Enter $title",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            onSave(textController.text.trim());
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
      ],
    ),
  );
}

Widget _buildRow(
    String title,
    String value, {
      bool isDropdown = false,
      bool isEditable = false,
      VoidCallback? onEditTap,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
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
            ),
            if (isDropdown)
              Icon(Icons.keyboard_arrow_down, color: Colors.black54),
            if (isEditable)
              InkWell(
                onTap: onEditTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.edit, size: 18),
                ),
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
        Obx(
          () => Row(
            children: [
              Text(
                controller.selectedProfession.value,
                style: TextStyle(
                  color:
                      controller.selectedProfession.value !=
                              "Fixed Charge Helper"
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          const Text(
                            "Choose Your Profession",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Center(
                              child: Text(
                                "Visiting Professional",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            onTap: () {
                              controller.setProfession("Visiting Professional");
                              Get.back();
                            },
                          ),
                          const Divider(),
                          ListTile(
                            title: const Center(
                              child: Text(
                                "Fixed Charge Helper",
                                style: TextStyle(color: Colors.orange),
                              ),
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
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
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
