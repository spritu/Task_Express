import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../colors.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
   SignUpView({super.key});

  // Create a GlobalKey for Form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              const Text(
                "Your Profile",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Obx(
                    () => Stack(
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
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Form(
                    key: _formKey,  // Assign the form key
                    child: Column(
                      children: [
                        buildTextField("First Name", "Enter first name", onChanged: (val) => controller.firstName.value = val, validator: (val) => val?.isEmpty ?? true ? 'First name is required' : null),
                        const SizedBox(height: 12),
                        buildTextField("Last Name", "Enter last name", onChanged: (val) => controller.lastName.value = val, validator: (val) => val?.isEmpty ?? true ? 'Last name is required' : null),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Gender", style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                              () => Row(
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildTextField("Date Of Birth", "DD/MM/YYYY",
                            icon: Icons.calendar_month,
                            isDate: true,
                            controller: controller.dobController,
                            onChanged: (val) => controller.dateOfBirth.value = val, validator: (val) => val?.isEmpty ?? true ? 'Date of birth is required' : null),
                        const SizedBox(height: 12),
                        buildTextField("Email", "Enter email",
                            onChanged: (val) => controller.email.value = val,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val?.isEmpty ?? true ? 'Email is required' : null),
                        const SizedBox(height: 12),
                        buildDropdown(
                          "State",
                          controller.stateCityMap.keys.toList(),
                          controller.state,
                          validator: (val) => val?.isEmpty ?? true ? 'State is required' : null,
                          onChanged: controller.onStateChanged, // 👈 triggers city reset
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => buildDropdown(
                                "City",
                                controller.citiesForSelectedState,
                                controller.city,
                                validator: (val) => val?.isEmpty ?? true ? 'City is required' : null,
                              )),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: buildTextField(
                                "Pin Code",
                                "Enter pin code",
                                keyboardType: TextInputType.number,
                                onChanged: (val) => controller.pinCode.value = val,
                             //   validator: (val) => val?.isEmpty ?? true ? 'Pin code is required' : null,
                              ),
                            ),
                          ],
                        ),


                        const SizedBox(height: 12),
                        buildTextField("Referral Code", "Enter referral code",
                            keyboardType: TextInputType.number,
                            onChanged: (val) => controller.referralCode.value = val,
                            //validator: (val) => val?.isEmpty ?? true ? 'Referral code is required' : null
                          ),
                        const SizedBox(height: 30),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.blue,
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Validate form before proceeding
                              if (_formKey.currentState?.validate() ?? false) {
                                controller.registerUser();
                              }
                            },
                            child: const Text("Proceed", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
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
        TextInputType? keyboardType,
        String? Function(String?)? validator,  // Validator function for validation
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isDate,
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
          keyboardType: keyboardType,
          validator: validator,  // Apply validator to TextFormField
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

   Widget buildDropdown(String label, List<String> items, RxString selectedValue,
       {String? hint, String? Function(String?)? validator, void Function(String)? onChanged}) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
         const SizedBox(height: 8),
         Obx(() => DropdownButtonFormField<String>(
           value: selectedValue.value.isNotEmpty ? selectedValue.value : null,
           icon: const Icon(Icons.keyboard_arrow_down),
           onChanged: (value) {
             if (value != null) {
               selectedValue.value = value;
               if (onChanged != null) onChanged(value);
             }
           },
           items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
           validator: validator,
           decoration: InputDecoration(
             hintText: hint ?? "Select",
             contentPadding: const EdgeInsets.symmetric(horizontal: 16),
             filled: true,
             fillColor: const Color(0xFFF4F8FF),
             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
             enabledBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(12),
               borderSide: const BorderSide(color: Colors.black26),
             ),
             errorBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(12),
               borderSide: const BorderSide(color: Colors.red),
             ),
             focusedErrorBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(12),
               borderSide: const BorderSide(color: Colors.red),
             ),
           ),
         )),
       ],
     );
   }



   void _showImagePicker(BuildContext context, SignUpController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        height: 160,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                controller.getImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                controller.getImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
