import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livelike_flutter_sdk/livelike_flutter_sdk.dart';

class TimeLineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimelinePage(title: "title");
  }
}

class TimelinePage extends StatefulWidget {
  TimelinePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> with AutomaticKeepAliveClientMixin<TimelinePage> {
  final _controller = Get.put(TimeLineController());

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Obx(
          () => _controller.session.value != null
              ? TimeLineView(
                  session: _controller.session.value!,
                  sepratorHeight: 100,
                  onInit: () {},
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class TimeLineController extends GetxController {
  final sdk = Get.find<EngagementSDK>();
  final session = Rx<Session?>(null);

  @override
  void onReady() async {
    super.onReady();
    session.value =
        await sdk.createSession("6834f1fd-f24d-4538-ba51-63544f9d78eb");
  }
}
