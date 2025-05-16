import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProviderHomeController extends GetxController {
  RxBool isAvailable2 = false.obs;
  var firstName = ''.obs;
  var userId = ''.obs;
  var imagePath = ''.obs;

  late IO.Socket socket;

  final count = 0.obs;
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
    loadUserInfo(); // Load user info and connect socket
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    firstName.value = prefs.getString('firstName') ?? '';
    userId.value = prefs.getString('userId') ?? '';
    imagePath.value = prefs.getString('userImg') ?? '';

    if (userId.value.isNotEmpty) {
      connectSocket();
    }
  }

  void connectSocket() {
    socket = IO.io("https://jdapi.youthadda.co", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'user': {
          '_id': userId.value,
          'firstName': firstName.value,
          'image': imagePath.value,
        },
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print("✅ Socket connected");

      // Optionally emit a room join or availability
      socket.emit("joinRoom", {"userId": userId.value});
    });

    socket.on("newBooking", (data) {
      print("📦 New Booking Received: $data");
      Get.snackbar("New Booking", "You have a new booking request!");
    });

    socket.onDisconnect((_) => print("❌ Socket disconnected"));
    socket.onConnectError((err) => print("🚫 Connect error: $err"));
    socket.onError((err) => print("🔥 Socket error: $err"));
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
        Get.snackbar("Success", "Availability updated successfully");

        // Emit availability status to socket server
        socket.emit("availabilityChange", {
          "userId": userId.value,
          "status": status ? 1 : 0,
        });
      } else {
        Get.snackbar("Error", "Failed to update availability");
        isAvailable2.value = !status;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
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
