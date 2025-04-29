import 'dart:io';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProviderChatScreenController extends GetxController {
  //TODO: Implement ProviderChatScreenController
  final RxList<types.Message> messages = <types.Message>[].obs;

  final types.User user = const types.User(id: 'user-123');

  @override
  void onInit() {
    super.onInit();
    messages.addAll([
      types.TextMessage(
        author: const types.User(id: 'admin'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: 'Welcome to the chat!',
      ),
    ]);
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    messages.insert(0, textMessage);
  }

  Future<void> handleImagePick() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result != null) {
      final file = File(result.path);

      final imageMessage = types.ImageMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        name: result.name,
        size: await file.length(),
        uri: file.path,
      );

      messages.insert(0, imageMessage);
    }
  }
}