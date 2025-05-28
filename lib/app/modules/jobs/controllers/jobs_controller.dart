import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

import '../../../../colors.dart';

class JobsController extends GetxController {
  //TODO: Implement JobsController
  int selectedIndex = 0;
  final count = 0.obs;
  var isLoading = false.obs;

  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  late IO.Socket socket;

  var bookingDataList = <Map<String, dynamic>>[].obs;

  Future<void> fetchCurrentBooking() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        //  Get.snackbar("Error", "User not logged in");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getserprorunningbooking'),
      );
      request.body = json.encode({
        "serviceProId": userId,
      }); // or hardcoded if needed
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📥 API Response Body123: $responseBody");

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(responseBody);
        if (jsonRes['data'] is List && jsonRes['data'].isNotEmpty) {
          bookingDataList.value = List<Map<String, dynamic>>.from(
            jsonRes['data'],
          );

          // Extract bookingId from first item (you can change index)
          String bookingId =
              bookingDataList[0]['_id']; // assuming _id is bookingId
          String phone = bookingDataList[0]['userMobile'] ?? "";
          await prefs.setString('currentBookingId', bookingId);
          await prefs.setString('currentBookingPhone', phone);
          print("💾 Booking ID saved to SharedPreferences12: $bookingId");
        } else {
          bookingDataList.clear();
        }

        if (jsonRes['data'] is List) {
          bookingDataList.value = List<Map<String, dynamic>>.from(
            jsonRes['data'],
          );
        } else {
          bookingDataList.clear();
        }
      } else {
        //  Get.snackbar("Error", "Failed to fetch booking");
      }
    } catch (e) {
      print("❌ Exception in fetchCurrentBooking: $e");
      // Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void connectSocketjobpay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print('55555: ${userId}');

    print("❌ wdwcdtf55 :${userId}");

    if (userId == null) {
      print("❌ User ID or BookedFor missing55");
      return;
    }

    print('🔌 Connecting socket for  Confirm payment: ${userId}');

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
      print('✅ Connected to socket55 Confirm payment');

      // final payload = {'receiver': bookedFor.trim()};
      //
      // print('📤 Emitting paybyuser payload55: $payload');
      // socket.emit('paybyuser', payload);
    });

    socket.on('paybyuser', (data) {
      print('📩 Received paybyuser  Confirm payment message1234: $data');
      print('Context: ${Get.context}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('Attempting to show bottom sheet');
        try {
          Get.bottomSheet(
                PaymentBottomSheet(), // Pass data to bottom sheet
                isScrollControlled: true,
              )
              .then((_) {
                print('Bottom sheet closed');
              })
              .catchError((error) {
                print('Error showing bottom sheet: $error');
              });
        } catch (e) {
          print('Exception in bottom sheet: $e');
        }
      });
      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId'] ?? 'unknown'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
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
    fetchCurrentBooking();
    //  connectSocketjobpay();
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

class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        gradient: AppColors.appGradient2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
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
            const Text(
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
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(label: 'User', value: 'Shivani Singh'),
                      InfoRow(label: 'Duration', value: '3 Hours'),
                      InfoRow(label: 'Date', value: '7 April, 2025'),
                      InfoRow(label: 'Time', value: '10:30 AM - 01:30 PM'),
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
                child: const Row(
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
                      '₹250',
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
                    onPressed: () => Get.back(),
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
                      // Accept Payment logic here
                      Get.back();
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

// class PaymentBottomSheet {
//   static void show(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.9,
//           decoration: BoxDecoration(
//             gradient: AppColors.appGradient2,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       onPressed: () => Get.back(),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Confirm Payment Received',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 16,
//                     fontFamily: 'poppins',
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Image.asset(
//                   'assets/images/payment_confirm.png',
//                   height: 246,
//                   width: 246,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'You’ve received a payment confirmation from the user. Please verify the amount received.',
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: 'poppins',
//                     fontWeight: FontWeight.w400,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Card(
//                   child: Container(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(
//                           blurRadius: 10,
//                           color: Colors.black12,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         InfoRow(label: 'User', value: 'Shivani Singh'),
//                         InfoRow(label: 'Duration', value: '3 Hours'),
//                         InfoRow(label: 'Date', value: '7 April, 2025'),
//                         InfoRow(label: 'Time', value: '10:30 AM - 01:30 PM'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Card(
//                   color: Colors.white,
//                   child: SizedBox(
//                     height: 44,
//                     width: 157,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Text(
//                           'Amount: ',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'poppins',
//                           ),
//                         ),
//                         Text(
//                           '₹250',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 37,
//                       width: 100,
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.orange),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: Colors.orange,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'poppins',
//                           ),
//                           maxLines: 1,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     SizedBox(
//                       height: 37,
//                       width: 147,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Accept Payment logic here
//                           Navigator.pop(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Accept Payment',
//                           style: TextStyle(
//                             fontFamily: 'poppins',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 11,
//                             color: Colors.white,
//                           ),
//                           maxLines: 1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const InfoRow({required this.label, required this.value, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(label, style: TextStyle(color: Colors.grey[700])),
//           ),
//           Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }
