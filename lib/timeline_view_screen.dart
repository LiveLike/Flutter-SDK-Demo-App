import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livelike_flutter_sdk/livelike_flutter_sdk.dart';


class TimeLineScreen extends StatelessWidget {
  final _controller = Get.put(TimeLineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("TimeLine"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Obx(
              () => _controller.session.value != null
              ? TimeLineView(
            session: _controller.session.value!,
            sepratorHeight: 100,
            onInit: () {
            },
          )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class TimeLineController extends GetxController {
  final sdk = Get.find<EngagementSDK>();
  final session = Rx<Session?>(null);

  @override
  void onReady() async {
    super.onReady();
    session.value = await sdk.createSession("6834f1fd-f24d-4538-ba51-63544f9d78eb");
  }
}
