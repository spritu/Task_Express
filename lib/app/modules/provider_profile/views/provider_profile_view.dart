import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../colors.dart';
import '../../provider_location/views/provider_location_view.dart';
import '../controllers/provider_profile_controller.dart';

class ProviderProfileView extends GetView<ProviderProfileController> {
  const ProviderProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderProfileController controller = Get.put(
      ProviderProfileController(),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appGradient2),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: controller.formKey, // ✅ Important
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
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
                          backgroundImage:
                              controller.imagePath.value.isNotEmpty
                                  ? FileImage(File(controller.imagePath.value))
                                  : null,
                          child:
                              controller.imagePath.value.isEmpty
                                  ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  )
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
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  buildTextField(
                    "First Name",
                    "Enter first name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name is required';
                      }
                      return null;
                    },
                    onChanged: (val) => controller.firstName.value = val,
                  ),
                  const SizedBox(height: 12),

                  buildTextField(
                    "Last Name",
                    "Enter last name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last Name is required';
                      }
                      return null;
                    },
                    onChanged: (val) => controller.lastName.value = val,
                  ),
                  const SizedBox(height: 20),

                  // Gender selection (No validation needed for now)
                  buildTextField(
                    "Date Of Birth",
                    "DD/MM/YYYY",
                    icon: Icons.calendar_month,
                    isDate: true,
                    controller: controller.dobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of Birth is required';
                      }
                      return null;
                    },
                    onChanged: (val) => controller.dateOfBirth.value = val,
                  ),
                  const SizedBox(height: 12),

                  buildTextField(
                    "Email",
                    "Enter email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!GetUtils.isEmail(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => controller.email.value = val,
                  ),  const SizedBox(height: 12),

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
                          validator: (val) => val?.isEmpty ?? true ? 'Pin code is required' : null,
                        ),
                      ),
                    ],
                  ),



                  const SizedBox(height: 12),

                  buildTextField(
                    "Referral Code",
                    "Enter referral code",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return null; // optional
                    },
                    onChanged: (val) => controller.referralCode.value = val,
                  ),

                  // Category, Profession, Work Experience dropdowns
                  // You can add validation on them too if needed
                  const SizedBox(height: 12),
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFEEDDD),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        buildDropdown2(
                          label: "Profession",
                          hint: "Select your Profession",
                          items: controller.professionList,
                          selectedValue: controller.selectedProfession,
                          onChanged: (value) {
                            controller.setSelectedProfession(value!);
                          },
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("category",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                        ),
                        Obx(() {
                          if (controller.categoryList.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100, // Background light grey
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                              border: Border.all(color: Colors.grey.shade300), // Light border
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  "Select your Category",
                                  //  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                ),
                                value: controller.selectedCategory.value.isNotEmpty
                                    ? controller.selectedCategory.value
                                    : null,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey.shade600,
                                  size: 24,
                                ),
                                items: controller.categoryList.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(
                                      category,
                                      style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.setSelectedCategory(newValue);
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                        buildDropdown2(
                          label: "Work Experience",
                          hint: "Select your Work Experience",
                          items: controller.workExperienceList,
                          selectedValue: controller.selectedWorkExperience,
                          onChanged: (value) {
                            controller.setSelectedWorkExperience(value!);
                          },
                        ),
                      ],
                    ),
                  ),
                  // Aadhaar field
                  // TextFormField(
                  //   controller: controller.aadharNo,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Aadhaar Number is required';
                  //     } else if (value.length != 12) {
                  //       return 'Aadhaar must be 12 digits';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: "Enter Aadhaar number",
                  //     filled: true,
                  //     fillColor: Color(0xFFF4F7FC),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  // ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Aadhaar Verification",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: "poppins",
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F7FC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Color(0xFF000000)),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TextField( keyboardType: TextInputType.number,
                                controller: controller.aadharNo,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Aadhaar number",
                                  hintStyle: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ), const SizedBox(height: 16),
                          Center(
                            child: Card(
                              child: Container(
                                height: 36,
                                width: 81,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFD1D1D1),
                                      blurRadius: 6.7,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    ShowmodelAdhar(context);
                                  },
                                  child: const Text(
                                    "Get OTP",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFF67C0A),
                                      fontFamily: "poppins",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Proceed Button
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF67C0A), Color(0xFFF67C0A)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFF67C0A),
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.submitForm();
                          Get.to(() => ProviderLocationView());
                        }
                      },
                      child: const Text(
                        "Proceed",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
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
    String? Function(String?)? validator, // <<=== ADD this line
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        TextFormField(
          // <<=== TextFormField instead of TextField
          controller: controller,
          readOnly: isDate,
          validator: validator,
          // <<=== ADD validator here
          onTap:
              isDate
                  ? () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      controller?.text = formattedDate;
                      if (onChanged != null) {
                        onChanged(formattedDate);
                      }
                    }
                  }
                  : null,
          onChanged: isDate ? null : onChanged,
          keyboardType: keyboardType,
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


  Widget stateDropdown(
    String label,
    String hint, {
    String? Function(String?)? validator, // <<=== Validator parameter add kiya
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            value:
                controller.selectState.value.isNotEmpty
                    ? controller.selectState.value
                    : null,
            icon: const Icon(Icons.keyboard_arrow_down),
            onChanged: (value) {
              controller.selectState.value = value ?? '';
            },
            items:
                controller.states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              filled: true,
              fillColor: const Color(0xFFF4F8FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black26),
              ),
            ),
            validator: validator, // <<=== Validator use kiya yahan
          ),
        ),
      ],
    );
  }

  Widget buildDropdown2({
    required String label,
    required String hint,
    required List<String> items,
    required RxString selectedValue,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Obx(
            () => DropdownButtonFormField<String>(
              value:
                  selectedValue.value.isNotEmpty ? selectedValue.value : null,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                onChanged(value);
              },
              items:
                  items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              decoration: const InputDecoration.collapsed(hintText: ""),
              hint: Text(hint),
            ),
          ),
        ),
      ],
    );
  }
}

void _showImagePicker(
  BuildContext context,
  ProviderProfileController controller,
) {
  showModalBottomSheet(
    context: context,
    builder:
        (context) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera, color: Colors.blue),
                title: const Text(
                  "Take Photo",
                  style: TextStyle(fontFamily: "poppins"),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.green),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(fontFamily: "poppins"),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text("Cancel", style: TextStyle(fontFamily: "poppins")),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
  );
}

void ShowmodelAdhar(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding:
            MediaQuery.of(context).viewInsets, // to handle keyboard overlap
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Aadhar Verification",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "poppins",
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "6-digit verification code sent to mobile number linked\nwith Aadhar XXXX XXXX XXXX 0786",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF717171),
                    fontFamily: "poppins",
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 12),

              /// OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 40,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      ShowmodelAdhar2(context);
                    },
                    child: const Text(
                      "Re-send",
                      style: TextStyle(
                        color: Color(0xFFF67C0A),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "poppins",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

void ShowmodelAdhar2(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Aadhar Verification",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: "poppins",
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "6-digit verification code sent to mobile number linked\nwith Aadhar XXXX XXXX XXXX 0786",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF717171),
                  fontFamily: "poppins",
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 12),

            /// OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => Container(
                  width: 40,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    ShowVerifiedAdhar(context);
                  },
                  child: Card(
                    child: Container(
                      height: 36,
                      width: 81,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            color: Color(0xFFF67C0A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "poppins",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}

void ShowVerifiedAdhar(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Aadhar Verification",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "poppins",
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFE4E4E4)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "XXXX XXXX XXXX 0786",
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3FBE5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Color(0xFF24B14B),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Verified",
                            style: TextStyle(
                              color: Color(0xFF24B14B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: "poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
