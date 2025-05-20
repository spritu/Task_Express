import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddAddressController extends GetxController {
  final houseNo = ''.obs;
  final landMark = ''.obs;
  final addressType = ''.obs;
  final contactNo = ''.obs;
  final count = 0.obs;
  RxList<dynamic> addressList = RxList<dynamic>();

  @override
  void onInit() {
    super.onInit();
    fetchAddress();
  }

  Future<void> fetchAddress() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        print("User ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/user/getmyaddress'));
      request.body = json.encode({"userId": userId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseString);

        if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
          var addressesList = jsonResponse['data'];

          addressList.clear();
          addressList.addAll(addressesList);

          print("Fetched addresses: ${addressList.length}");
        } else {
          print("No addresses found");
        }
      } else {
        print("Request failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        print("User ID not found");
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://jdapi.youthadda.co/user/deleteaddress'));
      request.body = json.encode({
        "userId": userId,
        "addressId": addressId,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        print('Address deleted: $responseString');

        addressList.removeWhere((address) => address['_id'] == addressId);

     //   Get.snackbar('Success', 'Address deleted successfully', snackPosition: SnackPosition.BOTTOM);

        // Optionally refresh fresh list:
        await fetchAddress();
      } else {
        print('Failed to delete address: ${response.reasonPhrase}');
     //   Get.snackbar('Error', 'Failed to delete address', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error deleting address: $e');
   //   Get.snackbar('Error', 'An error occurred while deleting the address', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
