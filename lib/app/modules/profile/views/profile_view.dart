import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worknest/colors.dart';
import '../../location/views/location_view.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration( gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87AAF6),
            Colors.white,
          ],
        ), ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                 Text(
                  "Your Profile",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.textColor),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Image.asset("assets/images/edit.png"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildTextField("First Name", "Enter first name"),
                const SizedBox(height: 12),
                buildTextField("Last Name", "Enter last name"),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Gender", style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: AppColors.textColor)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ["Female", "Male", "Other"]
                      .map((e) => Expanded(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.black26),
                        ),
                        onPressed: () {},
                        child: Text(e,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                buildTextField("Date Of Birth", "DD/MM/YYYY", icon: Icons.calendar_today),
                const SizedBox(height: 12),
                buildTextField("Email", "Enter email"),
                const SizedBox(height: 12),
                buildDropdown("State", "Select your State"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width*0.5,
                        child: buildDropdown("City", "Select your City")),
                    const SizedBox(width: 10),
                    SizedBox (width: MediaQuery.of(context).size.width/3,
                        child: buildTextField("Pin Code", "Enter pin code")),
                  ],
                ),

                const SizedBox(height: 12),
                buildTextField("Referral Code", "Enter referral code"),
                const SizedBox(height: 30),
                Container(width: MediaQuery.of(context).size.width*0.6,
                //  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0047FF), Color(0xFF0047FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff114BCA),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.to(LocationView());
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
    );
  }

  Widget buildTextField(String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w400,color: AppColors.textColor)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFFF4F8FF),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w400,color: AppColors.textColor)),
        const SizedBox(height: 8),
        Container(height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          child: DropdownButtonFormField<String>(
            value: null,
            icon: const Icon(Icons.keyboard_arrow_down),
            onChanged: (value) {},
            items: [],
            decoration: const InputDecoration.collapsed(hintText: "Select"),
            hint: Text(hint),
          ),
        ),
      ],
    );
  }
}
