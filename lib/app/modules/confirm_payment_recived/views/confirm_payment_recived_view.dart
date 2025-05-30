import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../colors.dart';
import '../../Bottom2/controllers/bottom2_controller.dart';
import '../controllers/confirm_payment_recived_controller.dart';

class ConfirmPaymentRecivedView
    extends GetView<ConfirmPaymentRecivedController> {
  final Map<String, dynamic> paymentData;
  const ConfirmPaymentRecivedView({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConfirmPaymentRecivedController>();

    final String bookingId = paymentData["_id"]?.toString() ?? 'N/A';
    final String amount = paymentData["pay"]?.toString() ?? '0';
    final String firstName = paymentData['bookedBy']?['firstName'] ?? 'User';
    final String lastName = paymentData['bookedBy']?['lastName'] ?? '';
    final String fullName = '$firstName $lastName';

    DateTime createdAt =
        DateTime.tryParse(paymentData['createdAt'] ?? '') ?? DateTime.now();
    DateTime updatedAt =
        DateTime.tryParse(paymentData['updatedAt'] ?? '') ?? DateTime.now();

    final formattedDate = DateFormat('d MMM, yyyy').format(createdAt);
    final startTime = DateFormat('hh:mm a').format(createdAt);
    final endTime = DateFormat('hh:mm a').format(updatedAt);

    final duration = updatedAt.difference(createdAt);
    final durationHours = duration.inHours;
    final durationMinutes = duration.inMinutes % 60;

    final String durationString =
        durationHours > 0
            ? '$durationHours Hours${durationMinutes > 0 ? " $durationMinutes Minutes" : ""}'
            : '$durationMinutes Minutes';
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        gradient: AppColors.appGradient2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              Text(
                'Confirm Payment Received',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: 'poppins',
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/payment_confirm.png',
                height: 246,
                width: 246,
              ),
              const SizedBox(height: 20),
              Text(
                'You’ve received a payment confirmation from the user. Please verify the amount received.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(label: 'User', value: "$fullName"),
                        InfoRow(label: 'Duration', value: durationString),
                        InfoRow(label: 'Date', value: formattedDate),
                        InfoRow(label: 'Time', value: '$startTime - $endTime'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                child: Container(
                  height: 44,
                  width: 157,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Amount: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'poppins',
                        ),
                      ),
                      Text(
                        '₹$amount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 37,
                    width: 100,
                    child: OutlinedButton(
                      onPressed: () {
                        print('button pressed');
                        controller.connectSocketCancel();
                        controller.sendPaymentConfirmation(
                          bookingId: bookingId,
                          acceptBySp: false,
                        );
                      },

                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'poppins',
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 37,
                    width: 147,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.sendPaymentConfirmation(
                          bookingId: bookingId,
                          acceptBySp: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Accept Payment',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Assuming InfoRow is defined elsewhere, if not, here's a sample implementation
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
