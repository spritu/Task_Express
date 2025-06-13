import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../views/recomplete_job_pay_view.dart';

class RecompleteJobPayController extends GetxController {
  //TODO: Implement RecompleteJobPayController

  final count = 0.obs;
  var bookingId1 = ''.obs;
  RxString bookedFor = ''.obs;

  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  late IO.Socket socket;
  var isUserPopupShown = false.obs;

  var pendingPaymentsUser = <Map<String, dynamic>>[].obs;
  var selectedPaymentUser = Rxn<Map<String, dynamic>>();
  TextEditingController payController = TextEditingController();

  String formatJobTime(String isoTimeString) {
    DateTime jobTime =
        DateTime.parse(isoTimeString).toLocal(); // convert to local time
    DateTime now = DateTime.now();

    String formattedTime = DateFormat('hh:mm a').format(jobTime);

    // Check if the date is today
    bool isToday =
        jobTime.year == now.year &&
        jobTime.month == now.month &&
        jobTime.day == now.day;

    if (isToday) {
      return " $formattedTime";
    } else {
      String formattedDate = DateFormat('dd MMM yyyy').format(jobTime);
      return " $formattedDate, $formattedTime";
    }
  }

  Future<void> fetchPendingPaymentsUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId == null) {
      print("Error: userId not found in SharedPreferences");
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/pendingpaymentuser'),
    );

    request.body = json.encode({"userId": userId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      var responseData = json.decode(res);

      if (responseData['count'] > 0) {
        pendingPaymentsUser.clear();

        for (var payment in responseData['data']) {
          pendingPaymentsUser.add(payment);
        }

        // ✅ Only show popup once
        if (!isUserPopupShown.value && pendingPaymentsUser.isNotEmpty) {
          selectedPaymentUser.value = pendingPaymentsUser.first;

          bookingId1.value = selectedPaymentUser.value!['_id'] ?? '';
          bookedFor.value =
              selectedPaymentUser.value!['bookedFor']['_id'] ?? '';

          print('✅ bookingId1 set to: ${bookingId1.value}');
          print('yyyyyyy:${selectedPaymentUser.value!['_id']}');
          print("zzzz:${bookedFor}");

          showConfirmPopup(selectedPaymentUser.value!);

          // ✅ Prevent future popups until reset
          isUserPopupShown.value = true;
        }
      } else {
        // No payments, reset state
        isUserPopupShown.value = false;
      }
    } else {
      print("❌ Error: ${response.reasonPhrase}");
    }
  }

  void showConfirmPopup(Map<String, dynamic> paymentData) {
    print("object77:${paymentData}");
    Get.showSnackbar(
      GetSnackBar(
        messageText: RecompleteJobPayView(paymentData: paymentData),
        isDismissible: false,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        //  duration: const Duration(hours: 1),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: 30,
      ),
    );
  }

  Future<void> closeJob(String bookingId) async {
    print('🔎 Booking ID inside closeJob: $bookingId');

    if (bookingId.isEmpty) {
      print('❌ bookingId is empty, cannot proceed.');
      return;
    }

    if (payController.text.isEmpty) {
      print('❌ Pay is empty');
      return;
    }

    final pay = int.tryParse(payController.text);
    if (pay == null) {
      print('❌ Invalid pay input');
      return;
    }

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/jobdone'),
    );

    request.body = json.encode({
      "bookingId": bookingId, // dynamic booking ID
      "pay": pay,
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        print('✅ Job closed successfully: $res');

        final jsonRes = json.decode(res);
        print('📦 bookingdddd: ${jsonRes['booking']}');
        print("eeeeeeeee$jsonRes");
        final idsend =
            jsonRes['booking']?['bookedFor']?['_id']?.toString() ?? '';
        final firstName =
            jsonRes['booking']?['bookedFor']?['firstName']?.toString() ?? '';
        final lastName =
            jsonRes['booking']?['bookedFor']?['lastName']?.toString() ?? '';

        print("gggggggggg $idsend $firstName$lastName");

        payController.clear();

        connectSocketjobpay(idsend, firstName, lastName); // Callback if needed
        Get.back(); // Close dialog or popup
      } else {
        print('❌ Server error: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  void connectSocketjobpay(
    String bookedFor,
    String firstName,
    String lastName,
  ) {
    print('bookedForbook: $bookedFor');
    print("❌ Recomplete : $bookedFor");

    if (bookedFor.isEmpty) {
      print("❌ User ID or BookedFor Recomplete");
      return;
    }

    print('🔌 Connecting socket for Recomplete: $bookedFor');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': bookedFor,
          'firstName': firstName,
          'lastName': lastName,
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket Recomplete pay done');
      print('✅ bookedFor.trim() ${bookedFor.trim()}');

      final payload = {'receiver': bookedFor.trim()};
      print('📤 Emitting paybyuser payload55: $payload');
      socket.emit('paybyuser', payload);
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected from socket');
    });

    socket.onConnectError((err) {
      print('🚫 Connect Error: $err');
    });

    socket.onError((err) {
      print('🔥 Socket Error: $err');
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
    payController.dispose();
  }

  void increment() => count.value++;
}
