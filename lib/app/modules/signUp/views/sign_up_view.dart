import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../colors.dart';
import '../../location/views/location_view.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87AAF6), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
        children: [
        const SizedBox(height: 10),
        const Text("Your Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),

        /// Fixed Profile Image
        Obx(() => Stack(
          alignment: Alignment.bottomRight,
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
              right: 4,
              child: InkWell(
                onTap: () => _showImagePicker(context, controller),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/images/edit.png", height: 16),
                ),
              ),
            ),
          ],
        )),
        const SizedBox(height: 20),

        /// Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                buildTextField("First Name", "Enter first name", onChanged: (val) => controller.firstName.value = val),
                const SizedBox(height: 12),
                buildTextField("Last Name", "Enter last name", onChanged: (val) => controller.lastName.value = val),
                const SizedBox(height: 20),

                const Align(alignment: Alignment.centerLeft, child: Text("Gender", style: TextStyle(fontSize: 12))),
                const SizedBox(height: 10),
                Obx(() => Row(
                  children: ["Female", "Male", "Other"].map((e) {
                    final isSelected = controller.gender.value == e;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected ? AppColors.blue : Colors.white,
                            side: BorderSide(color: isSelected ? AppColors.blue : Colors.black26),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => controller.gender.value = e,
                          child: Text(
                            e,
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                const SizedBox(height: 20),
                buildTextField(
                  "Date Of Birth",
                  "DD/MM/YYYY",
                  icon: Icons.calendar_month,
                  isDate: true,
                  controller: controller.dobController,
                  onChanged: (val) => controller.dateOfBirth.value = val,
                ),

                const SizedBox(height: 12),
                buildTextField("Email", "Enter email", onChanged: (val) => controller.email.value = val),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: buildDropdown("City", ["Rewa", "Bhopal", "Indore"], controller.city)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: buildTextField("Pin Code", "Enter pin code", onChanged: (val) => controller.pinCode.value = val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                buildDropdown("State", ["MP", "UP", "MH"], controller.state),
                const SizedBox(height: 12),
                buildTextField("Referral Code", "Enter referral code", onChanged: (val) => controller.referralCode.value = val),
                const SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.blue,
                  ),
                  child: TextButton(
                    onPressed: () { controller.registerUser();
                    Get.to(() => LocationView());},
                    child: const Text("Proceed", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        ],
      ),

    ),
      ),
    );
  }

  Widget buildTextField(
      String label,
      String hint, {
        IconData? icon,
        Function(String)? onChanged,
        bool isDate = false,
        TextEditingController? controller,
      }) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: isDate, // only make it readonly for date
          onTap: isDate
              ? () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              controller?.text = formattedDate;
              if (onChanged != null) {
                onChanged(formattedDate);
              }
            }
          }
              : null,
          onChanged: isDate ? null : onChanged,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: const Color(0xFFF4F8FF),
          ),
        ),
      ],
    );
  }


  Widget buildDropdown(String label, List<String> items, RxString selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        Obx(() => Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: DropdownButtonFormField<String>(
              value: selectedValue.value.isNotEmpty ? selectedValue.value : null,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                if (value != null) selectedValue.value = value;
              },
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              decoration: const InputDecoration.collapsed(hintText: "Select"),
            ),
          ),
        )),
      ],
    );
  }

  void _showImagePicker(BuildContext context, SignUpController controller) {
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
