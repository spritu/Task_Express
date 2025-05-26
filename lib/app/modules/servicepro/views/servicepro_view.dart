import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../colors.dart';
import '../controllers/servicepro_controller.dart';

class ServiceproView extends GetView<ServiceproController> {
  const ServiceproView({super.key});
  @override
  Widget build(BuildContext context) {  Get.put(ServiceproController());
    final arguments = Get.arguments as Map<String, dynamic>;
    final List users = arguments['users'];
    final String title = arguments['title'] ?? 'Professionals';
    return Scaffold(
      backgroundColor: const Color(0xFFD9E4FC),
      appBar: AppBar(
        backgroundColor: Color(0xFFD9E4FC),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w400,
            fontFamily: "poppins",
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'No service provider in this category ',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
