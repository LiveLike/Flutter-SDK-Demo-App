import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livelike_flutter_sdk/livelike_flutter_sdk.dart';


class ChatScreen extends StatelessWidget {
  final _controller = Get.put(ChatViewController());

  ChatScreen(Rx<ChatSession?> chatSession);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Obx(
              () => _controller.chatSession.value != null
              ? ChatView(
                key: Key("${_controller.chatSession.value!.chatRoomId}"),
                session: _controller.chatSession.value!,
              )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class ChatViewController extends GetxController {
  final sdk = Get.find<EngagementSDK>();
  final chatSession = Rx<ChatSession?>(null);

  @override
  void onReady() async {
    super.onReady();
    chatSession.value = await sdk.createChatSession("812b63c4-c8bb-4133-9fab-e6111cc4bf27");
  }
}
