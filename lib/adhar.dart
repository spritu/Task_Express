import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aadhaar Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AadhaarVerificationScreen(),
    );
  }
}

class AadhaarVerificationScreen extends StatefulWidget {
  @override
  _AadhaarVerificationScreenState createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState
    extends State<AadhaarVerificationScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();

  Future<void> verifyAadhaar() async {
    final response = await ApiService.verifyAadhaar(
      _aadhaarController.text,
      _captchaController.text,
    );

    if (response != null) {
      print('Verification Response: $response');
    } else {
      print('Failed to verify Aadhaar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aadhaar Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _aadhaarController,
              decoration: InputDecoration(labelText: 'Aadhaar Number'),
            ),
            TextField(
              controller: _captchaController,
              decoration: InputDecoration(labelText: 'Captcha Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyAadhaar,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
