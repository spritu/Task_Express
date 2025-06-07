import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../colors.dart';
import '../controllers/provider_edit_profile_controller.dart';

class ProviderEditProfileView extends GetView<ProviderEditProfileController> {
  const ProviderEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProviderEditProfileController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: AppColors.appGradient2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                    const Text("Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: "poppins")),
                    const SizedBox(width: 48),
                  ],
                ),

                Obx(() {
                  final imagePath = controller.imagePath.value;
                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: imagePath.isNotEmpty
                            ? (imagePath.startsWith("http")
                            ? NetworkImage(imagePath)
                            : FileImage(File(imagePath)) as ImageProvider)
                            : null,
                        child: imagePath.isEmpty
                            ? const Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () => _showImagePicker(context, controller),
                          child: Image.asset("assets/images/edit1.png", width: 30),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 20),

                Card(
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildEditableField("Full Name", controller.nameController, controller),
                        _buildEditableField("Gender", controller.genderController, controller),
                        _buildEditableField("Date Of Birth", controller.dobController, controller),
                        _buildEditableField("Email", controller.emailController, controller),
                      ],
                    ),

                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orage,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await controller.updateUser(imageFilePath: controller.imagePath.value);
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

  Widget _buildEditableField(
      String label, TextEditingController textController, ProviderEditProfileController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(textController.text, style: const TextStyle(color: Colors.grey)),
              IconButton(
                onPressed: () async {
                  final result = await showDialog<String>(
                    context: Get.context!,
                    builder: (context) {
                      final tempController = TextEditingController(text: textController.text);
                      return AlertDialog(
                        title: Text("Edit $label"),
                        content: TextField(
                          controller: tempController,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                        ),
                        actions: [
                          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                          TextButton(
                            onPressed: () => Get.back(result: tempController.text.trim()),
                            child: const Text("Save"),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null && result.isNotEmpty) {
                    textController.text = result;
                    controller.update();
                  }
                },
                icon: const Icon(Icons.edit, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  } void _showImagePicker(BuildContext context, ProviderEditProfileController controller) {
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