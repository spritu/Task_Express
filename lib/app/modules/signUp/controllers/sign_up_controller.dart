import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class SignUpController extends GetxController {
  final firstName = ''.obs;
  final lastName = ''.obs;
  final gender = ''.obs;
  final dateOfBirth = ''.obs;
  final email = ''.obs;
  final city = ''.obs;
  final pinCode = ''.obs;
  final state = ''.obs;
  final referralCode = ''.obs;
  final RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imagePath.value = image.path;
      update();
    }
  }

  Future<void> registerUser() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://jdapi.youthadda.co/user/register'),
    );

    request.fields.addAll({
      'firstName': firstName.value,
      'lastName': lastName.value,
      'gender': gender.value,
      'dateOfBirth': dateOfBirth.value,
      'email': email.value,
      'city': city.value,
      'pinCode': pinCode.value,
      'state': state.value,
      'referralCode': referralCode.value,
    });

    if (imagePath.value.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('userImg', imagePath.value));
    }

    try {
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resBody = await response.stream.bytesToString();
        print('✅ Response: $resBody');
        Get.snackbar('Success', 'Registration Successful');

        // ✅ Navigate to LocationView
       // Get.to(() => LocationView());

      } else {
        final resBody = await response.stream.bytesToString();
        print('❌ Server Error (${response.statusCode}): $resBody');
        Get.snackbar('Error', 'Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
      Get.snackbar('Error', 'Could not register. Check your internet or server.');
    }
  }


}
