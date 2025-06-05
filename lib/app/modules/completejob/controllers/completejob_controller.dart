import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../ServiceCompleted/views/service_completed_view.dart';

class CompletejobController extends GetxController {
  //TODO: Implement CompletejobController

  final count = 0.obs;

  late var bookedby = ''.obs;
  late var bookedFor = ''.obs;
  late var firstName = ''.obs;
  late var lastName = ''.obs;

  var bookingId = ''.obs;
  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  late IO.Socket socket;

  TextEditingController payController = TextEditingController();
  final Map<String, dynamic> booking = Get.arguments;

  // Function to call API and close job
  Future<void> closeJob(String bookingId) async {
    if (payController.text.isEmpty) {
      print('❌ Pay is empty');
      return;
    }
    print('new: ${booking}');
    final pay = int.tryParse(payController.text);
    if (pay == null) {
      print('❌ Invalid pay input');
      return;
    }

    final url = Uri.parse('https://jdapi.youthadda.co/jobdone');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({"bookingId": bookingId, "pay": pay});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        connectSocketjobpay();
        Get.to(ServiceCompletedView(), arguments: booking);
        print('✅ Success: ${response.body}');
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }

  String formatCreatedAt1234(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final date =
          "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
      final time =
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      return "$date, $time";
    } catch (e) {
      return "Invalid date";
    }
  }

  void connectSocketjobpay() {
    print('55555: ${bookedFor}');

    print("❌ wdwcdtf55 :${bookedFor}");

    if (bookedFor == null) {
      print("❌ User ID or BookedFor missing55");
      return;
    }

    print('🔌 Connecting socket for user55: ${bookedFor.value}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': bookedFor.value,
          'firstName': firstName.value,
          'lastName': lastName.value,
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket55 pay done');

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

    final Map<String, dynamic> booking = Get.arguments;
    print('65656565:${booking}');

    bookingId.value = booking['data']['_id'];

    bookedby.value = booking['data']['bookedBy']['_id'];

    bookedFor.value = booking['data']['bookedFor']['_id'];

    firstName.value = booking['data']['bookedFor']['firstName'];
    lastName.value = booking['data']['bookedFor']['lastName'];

    print("📦 Booking ID: $bookingId");
    print("👤 Booked By User ID: ${bookedby.value}");

    closeJob(bookingId.value);
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
