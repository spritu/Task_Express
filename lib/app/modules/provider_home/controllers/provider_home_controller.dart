// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:url_launcher/url_launcher.dart';
//
// class ProviderHomeController extends GetxController {
//   RxBool isAvailable2 = false.obs;
//
//   var firstName = ''.obs;
//   var userId = ''.obs;
//   var imagePath = ''.obs;
//   var isLoading = false.obs;
//   var bookingDataList = <Map<String, dynamic>>[].obs;
//   RxString bookingId = ''.obs;
//   RxString phoneNumber = ''.obs;
//
//   late IO.Socket socket;
//   void makePhoneCall() async {
//     if (phoneNumber != null && phoneNumber!.isNotEmpty) {
//       final Uri callUri = Uri(scheme: 'tel', path: phoneNumber.toString());
//       if (await canLaunchUrl(callUri)) {
//         await launchUrl(callUri);
//       } else {
//         print("❌ Cannot call");
//       }
//     }
//   }
//   final count = 0.obs;
//   var isAvailable = true.obs;
//   var isServiceProfile = false.obs;
//
//   final List<Map<String, String>> jobs = List.generate(
//     3,
//     (index) => {
//       "title": "Plumbing job",
//       "subtitle": "Pipe Repair",
//       "amount": "₹8450",
//       "date": "10 Apr 2025",
//     },
//   );
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadUserInfo(); // Load user info and connect socket
//     fetchCurrentBooking();
//   }
//
//   var bookingData = {}.obs;
//
//
//
//   Future<void> fetchCurrentBooking() async {
//     try {
//       isLoading.value = true;
//
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userId = prefs.getString('userId');
//
//       if (userId == null) {
//      //   Get.snackbar("Error", "User not logged in");
//         return;
//       }
//
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
//       );
//       request.body = json.encode({
//         "serviceProId": userId,
//       }); // or hardcoded if needed
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//       String responseBody = await response.stream.bytesToString();
//
//       print("📥 API Response Body: $responseBody");
//
//       if (response.statusCode == 200) {
//         var jsonRes = jsonDecode(responseBody);
//         if (jsonRes['data'] is List && jsonRes['data'].isNotEmpty) {
//           bookingDataList.value = List<Map<String, dynamic>>.from(
//             jsonRes['data'],
//           );
//
//           // Extract bookingId from first item (you can change index)
//           String bookingId =
//               bookingDataList[0]['_id']; // assuming _id is bookingId
//           String phone = bookingDataList[0]['userMobile'] ?? "";
//           await prefs.setString('currentBookingId', bookingId);
//           await prefs.setString('currentBookingPhone', phone);
//           print("💾 Booking ID saved to SharedPreferences: $bookingId");
//         } else {
//           bookingDataList.clear();
//         }
//
//         if (jsonRes['data'] is List) {
//           bookingDataList.value = List<Map<String, dynamic>>.from(
//             jsonRes['data'],
//           );
//         } else {
//           bookingDataList.clear();
//         }
//       } else {
//      //   Get.snackbar("Error", "Failed to fetch booking");
//       }
//     } catch (e) {
//       print("❌ Exception in fetchCurrentBooking: $e");
//      // Get.snackbar("Error", "Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   // void fetchCurrentBooking() async {
//   //   try {
//   //     var response = await http.post(
//   //       Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
//   //       body: json.encode({"serviceProId": userId}),
//   //       headers: {'Content-Type': 'application/json'},
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       var jsonRes = json.decode(response.body);
//   //       if (jsonRes['data'] is List && jsonRes['data'].isNotEmpty) {
//   //         bookingId = jsonRes['data'][0]['_id'];
//   //         phoneNumber = jsonRes['data'][0]['phone'];
//   //         // OR (if using Rx)
//   //         // bookingId.value = jsonRes['data'][0]['_id'];
//   //         // phoneNumber.value = jsonRes['data'][0]['userMobile'];
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print("❌ Error: $e");
//   //   }
//   // }
//
//   Future<void> updateBookingStatus({required String acceptStatus}) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? bookingId = prefs.getString('currentBookingId');
//
//       if (bookingId == null) {
//       //  Get.snackbar("Error", "Booking ID not found");
//         return;
//       }
//
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('https://jdapi.youthadda.co/acceptreject'),
//       );
//
//       request.body = json.encode({
//         "bookingId": bookingId,
//         "accept": acceptStatus, // pass "yes" or "no"
//       });
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200) {
//         var resBody = await response.stream.bytesToString();
//         print("✅ Booking status updated: $resBody");
//       } else {
//         print("❌ Error: ${response.reasonPhrase}");
//        // Get.snackbar("Error", "Failed to update status");
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//     //  Get.snackbar("Error", "Exception: $e");
//     }
//   }
//
//   Future<void> loadUserInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     firstName.value = prefs.getString('firstName') ?? '';
//     userId.value = prefs.getString('userId') ?? '';
//     imagePath.value = prefs.getString('userImg') ?? '';
//
//     if (userId.value.isNotEmpty) {
//       connectSocket();
//     }
//   }
//
//   void connectSocket() {
//     socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//       'auth': {
//         'user': {
//           '_id': userId.value,
//           'firstName': firstName.value,
//           'image': imagePath.value,
//         },
//       },
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       print("✅ Socket connected");
//
//       // Optionally emit a room join or availability
//       socket.emit("joinRoom", {"userId": userId.value});
//     });
//
//     socket.on("newBooking", (data) {
//       print("📦 New Booking Received: $data");
//     //  Get.snackbar("New Booking", "You have a new booking request!");
//     });
//
//     socket.onDisconnect((_) => print("❌ Socket disconnected"));
//     socket.onConnectError((err) => print("🚫 Connect error: $err"));
//     socket.onError((err) => print("🔥 Socket error: $err"));
//   }
//
//   Future<void> updateAvailability(bool status) async {
//     try {
//       final headers = {'Content-Type': 'application/json'};
//       final body = json.encode({
//         "serviceProId": userId.value,
//         "avail": status ? 1 : 0,
//       });
//
//       final response = await http.post(
//         Uri.parse('https://jdapi.youthadda.co/user/changeavailstatus'),
//         headers: headers,
//         body: body,
//       );
//
//       if (response.statusCode == 200) {
//       //  Get.snackbar("Success", "Availability updated successfully");
//
//         // Emit availability status to socket server
//         socket.emit("availabilityChange", {
//           "userId": userId.value,
//           "status": status ? 1 : 0,
//         });
//       } else {
//       //  Get.snackbar("Error", "Failed to update availability");
//         isAvailable2.value = !status;
//       }
//     } catch (e) {
//      // Get.snackbar("Error", "Something went wrong");
//       isAvailable2.value = !status;
//     }
//   }
//
//   @override
//   void onClose() {
//     socket.dispose();
//     super.onClose();
//   }
//
//   void increment() => count.value++;
// }
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ProviderHomeController extends GetxController {
  RxBool isAvailable2 = false.obs;

  var firstName = ''.obs;
  var userId = ''.obs;
  var imagePath = ''.obs;
  var isLoading = false.obs;
  var bookingDataList = <Map<String, dynamic>>[].obs;
  var DataList = <Map<String, dynamic>>[].obs;

  final RxList<types.Message> messages = <types.Message>[].obs;
  final Rxn<types.User> user = Rxn<types.User>();
  var bookedBy=''.obs ;
  RxString bookedFor = ''.obs;


  late IO.Socket socket;

  var count = 0.obs;
  var isAvailable = true.obs;
  var isServiceProfile = false.obs;

  final List<Map<String, String>> jobs = List.generate(
    3,
        (index) => {
      "title": "Plumbing job",
      "subtitle": "Pipe Repair",
      "amount": "₹8450",
      "date": "10 Apr 2025",
    },
  );

  @override
  void onInit() {
    super.onInit();
    connectSocket();
    loadUserInfo(); // Load user info and connect socket
    fetchCurrentBooking();
  }
  void connectSocketAccept() {
    print('444444: ${bookedBy}');


    print("❌ wdwcdtf :${userId}");

    if (userId == null) {
      print("❌ User ID or BookedFor missing");
      return;
    }

    print('🔌 Connecting socket for user: ${userId.value}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': userId.value,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket');

      final payload = {
        'receiver':bookedBy.trim(),

      };

      print('📤 Emitting acceptBooking payload: $payload');
      socket.emit('acceptBooking', payload);
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

  void connectSocketReject() {
    print('55555: ${bookedBy}');


    print("❌ wdwcdtf55 :${userId}");

    if (userId == null) {
      print("❌ User ID or BookedFor missing55");
      return;
    }

    print('🔌 Connecting socket for user55: ${userId.value}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': userId.value,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket55');

      final payload = {
        'receiver':bookedBy.trim(),

      };

      print('📤 Emitting rejectBooking payload55: $payload');
      socket.emit('rejectBooking', payload);
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
  var bookingData = {}.obs;
  void makePhoneCallFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('currentBookingPhone');

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
   //     Get.snackbar("Error", "Cannot make call to $phoneNumber");
      }
    } else {
   //   Get.snackbar("Error", "Phone number not available");
    }
  }



  Future<void> fetchCurrentBooking() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      print('servicenew:${userId}');

      if (userId == null) {
      //  Get.snackbar("Error", "User not logged in");
        return;
      }


      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/getserprocurrentbooking'),
      );
      request.body = json.encode({
        "serviceProId": userId,
      }); // or hardcoded if needed
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📥 API Response Body: $responseBody");

      if (response.statusCode == 200) {
        var jsonRes = jsonDecode(responseBody);
        // bookedBy = jsonRes['data'][0]['bookedBy']['_id'];
        bookedBy.value = jsonRes['data'][0]['bookedBy']['_id'];

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
          print("💾 Booking ID saved to SharedPreferences: $bookingId");
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
    //  Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBookingStatus({required String acceptStatus}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bookingId = prefs.getString('currentBookingId');

      if (bookingId == null) {
      //  Get.snackbar("Error", "Booking ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://jdapi.youthadda.co/acceptreject'),
      );

      request.body = json.encode({
        "bookingId": bookingId,
        "accept": acceptStatus, // pass "yes" or "no"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var resBody = await response.stream.bytesToString();
        print("✅ Booking status updated: $resBody");
        connectSocketAccept();
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        //Get.snackbar("Error", "Failed to update status");
      }
    } catch (e) {
      print("❌ Exception: $e");
     // Get.snackbar("Error", "Exception: $e");
    }
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    firstName.value = prefs.getString('firstName') ?? '';
    userId.value = prefs.getString('userId') ?? '';
    imagePath.value = prefs.getString('userImg') ?? '';

    print("dddd: ${DataList}");

    if (userId.value.isNotEmpty) {
      connectSocket();
    }
  }

  void connectSocket() {
    print("❌ wdwcdtf :${userId}");

    if (userId == null) {
      print("❌ User ID or BookedFor missing");
      return;
    }

    print('🔌 Connecting socket for user: ${userId}');

    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'auth': {
        'user': {
          '_id': userId.value,
          'firstName': 'plumber naman', // Optional, can be dynamic
        },
      },
    });

    socket.connect();

    // socket.onConnect((_) {
    //   print('✅ Connected to socket12121212');
    // });

    socket.onConnect((_) {
      print('✅ Connected to socket');
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

    /// ✅ Listen to newBooking messages
    socket.on('newBooking', (data) {
      print('📩 Received newBooking message: $data');
      fetchCurrentBooking();

      final msg = types.TextMessage(
        id: data['_id'] ?? const Uuid().v4(),
        text: data['message'] ?? '',
        author: types.User(id: data['senderId'] ?? 'unknown'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      messages.insert(0, msg);
    });
  }





  Future<void> updateAvailability(bool status) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        "serviceProId": userId.value,
        "avail": status ? 1 : 0,
      });

      final response = await http.post(
        Uri.parse('https://jdapi.youthadda.co/user/changeavailstatus'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
       // Get.snackbar("Success", "Availability updated successfully");

        // Emit availability status to socket server
        socket.emit("availabilityChange", {
          "userId": userId.value,
          "status": status ? 1 : 0,
        });
      } else {
      //  Get.snackbar("Error", "Failed to update availability");
        isAvailable2.value = !status;
      }
    } catch (e) {
    //  Get.snackbar("Error", "Something went wrong");
      isAvailable2.value = !status;
    }
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}