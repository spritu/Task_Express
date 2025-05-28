import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/confirm_payment_recived_controller.dart';

class ConfirmPaymentRecivedView
    extends GetView<ConfirmPaymentRecivedController> {
  const ConfirmPaymentRecivedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConfirmPaymentRecivedView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConfirmPaymentRecivedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
