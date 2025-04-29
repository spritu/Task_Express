import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../colors.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: AppColors.appGradient),
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text("     "),
                  ],
                ),
                Obx(() => Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: controller.imagePath.value.isNotEmpty
                          ? FileImage(File(controller.imagePath.value))
                          : null,
                      child: controller.imagePath.value.isEmpty
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => _showImagePicker(context, controller),
                        child: Image.asset("assets/images/edit1.png"),
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 20),
                Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildEditableField(
                          "Full Name",
                          controller.nameController,
                          controller.isEditingName,
                              () {
                            controller.isEditingName = !controller.isEditingName;
                          },
                        ),
                        _buildEditableField(
                          "Gender",
                          controller.genderController,
                          controller.isEditingGender,
                              () {
                            controller.isEditingGender = !controller.isEditingGender;
                          },
                        ),
                        _buildEditableField(
                          "Date Of Birth",
                          controller.dobController,
                          controller.isEditingDOB,
                              () {
                            controller.isEditingDOB = !controller.isEditingDOB;
                          },
                        ),
                        _buildEditableField(
                          "Email",
                          controller.emailController,
                          controller.isEditingEmail,
                              () {
                            controller.isEditingEmail = !controller.isEditingEmail;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff114BCA),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    controller.updateUser();
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "poppins",
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
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

  Widget _buildEditableField(String label,
      TextEditingController controller,
      bool isEditing,
      VoidCallback onEditPressed,) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.text,
                style: const TextStyle(color: Colors.grey),
              ),
              IconButton(
                onPressed: () async {
                  final result = await showDialog<String>(
                    context: Get.context!,
                    builder: (context) {
                      final TextEditingController tempController = TextEditingController(text: controller.text);
                      return AlertDialog(
                        title: Text("Edit $label"),
                        content: TextField(
                          controller: tempController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, tempController.text.trim());
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null && result.isNotEmpty) {
                    controller.text = result;
                  }
                },
                icon: const Icon(Icons.edit, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context, EditProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.blue),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                controller.getImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.green),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                controller.getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text("Cancel"),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}
