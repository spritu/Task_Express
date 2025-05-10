import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfessionalProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxList users = [].obs;
  RxInt selectedIndex = (-1).obs;

  void fetchUsersListByCategory(String catId) async {
    isLoading.value = true;
    try {
      var url = Uri.parse('https://jdapi.youthadda.co/user/getusersbycatsubcat?id=67ffa378ff5aa0d5e1549422');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        users.assignAll(jsonData['data'] ?? []);
        if (users.isEmpty) {
          Get.snackbar("Info", "No data found");
        }
      } else {
        Get.snackbar("Server Error", "Status Code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleProfileView(int index) {
    selectedIndex.value = selectedIndex.value == index ? -1 : index;
  }
}
