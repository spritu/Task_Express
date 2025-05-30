import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../views/confirm_payment_recived_view.dart';

class ConfirmPaymentRecivedController extends GetxController {
  final count = 0.obs;
  var payment = ''.obs;
  var pendingPayments = <Map<String, dynamic>>[].obs;
  var selectedPayment = <String, dynamic>{}.obs;
  late IO.Socket socket;
  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  var isPopupShown = false.obs;

  //RxList<Map<String, dynamic>> pendingPayments = <Map<String, dynamic>>[].obs;

  // Future<void> fetchPendingPayments() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? serviceProId = prefs.getString("userId");
  //
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request(
  //     'POST',
  //     Uri.parse('https://jdapi.youthadda.co/pendingpaymentsp'),
  //   );
  //
  //   request.body = json.encode({"serviceProId": serviceProId});
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     String res = await response.stream.bytesToString();
  //     var responseData = json.decode(res);
  //
  //     if (responseData['count'] > 0) {
  //       for (var payment in responseData['data']) {
  //         print('12121212:${payment}');
  //         pendingPayments.add(payment);
  //         //  Set the globally accessible payment here
  //         selectedPayment.value = payment;
  //         print("xxxxxxxxxxxx: ${selectedPayment.value}");
  //         showConfirmPopup(payment);
  //       }
  //     }
  //   } else {
  //     print("Error: ${response.reasonPhrase}");
  //   }
  // }
  //
  // void showConfirmPopup(Map<String, dynamic> paymentData) {
  //   Get.showSnackbar(
  //     GetSnackBar(
  //       messageText: ConfirmPaymentRecivedView(paymentData: paymentData),
  //       isDismissible: false,
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.transparent,
  //       //  duration: const Duration(hours: 1),
  //       margin: EdgeInsets.zero,
  //       padding: EdgeInsets.zero,
  //       borderRadius: 30,
  //     ),
  //   );
  // }

  Future<void> fetchPendingPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? serviceProId = prefs.getString("userId");

    if (serviceProId == null) {
      print("User ID not found");
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/pendingpaymentsp'),
    );

    request.body = json.encode({"serviceProId": serviceProId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      var responseData = json.decode(res);

      if (responseData['count'] > 0) {
        pendingPayments.clear();

        for (var payment in responseData['data']) {
          pendingPayments.add(payment);
        }

        // ✅ Only show if not already shown
        if (!isPopupShown.value) {
          selectedPayment.value = pendingPayments.first;
          isPopupShown.value = true; // ✅ Set flag
          showConfirmPopup(selectedPayment.value);
        }
      } else {
        // Reset if no pending payments
        isPopupShown.value = false;
      }
    } else {
      print("Error: ${response.reasonPhrase}");
    }
  }

  void showConfirmPopup(Map<String, dynamic> paymentData) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: ConfirmPaymentRecivedView(paymentData: paymentData),
        isDismissible: false,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: 30,
      ),
    );
  }

  Future<void> sendPaymentConfirmation({
    required String bookingId,
    required bool acceptBySp,
  }) async {
    final url = Uri.parse("https://jdapi.youthadda.co/spaccept");

    final Map<String, dynamic> bodyData = {
      "bookingId": bookingId.trim(),
      "acceptbysp": acceptBySp, // convert to string "true"/"false"
    };

    print(" Sending payment confirmation...");
    print("Request body: $bodyData");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    print(" Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("Payment confirmation sent: $acceptBySp");
      fetchPendingPayments(); // refresh the list
      Get.back(); // close popup
    } else {
      print(" Failed to send payment confirmation");
    }
  }

  void connectSocketCancel() async {
    final userId = selectedPayment['bookedBy']['_id'];

    print(" CancelUser:${userId}");

    if (userId == null) {
      print("User ID or BookedFor missing cancel");
      return;
    }

    print('🔌 Connecting socket for user cancel: ${userId}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': userId,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket cancelby sp');

      final payload = {'receiver': userId.trim()};

      print('📤 Emitting paybyuserconfirm payload55: $payload');
      socket.emit('paybyuserconfirm', payload);
    });

    socket.onDisconnect((_) {
      print(' Disconnected from socket');
    });

    socket.onConnectError((err) {
      print(' Connect Error: $err');
    });

    socket.onError((err) {
      print(' Socket Error: $err');
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
