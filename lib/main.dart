import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livelike_flutter_sdk/livelike_flutter_sdk.dart';
import 'package:livelike_sdk_example/timeline_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'LiveLike SDK Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        getPages: [
          GetPage(name: "widgets", page: () => TimeLineScreen()),
        ],
        home: SizedBox(child: MyHomePage(title: 'LiveLike SDK Demo')));
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Tabs Demo'),
          bottom: TabBar(
            tabs: [
               Tab(icon: Icon(Icons.chat), text: "Chat"),
               Tab(icon: Icon(Icons.timeline), text: "Timeline")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(
            () => homeController.chatLoaded.value ? ChatScreen(homeController.chatSession) : SizedBox.shrink()),
            Obx(
              () => homeController.chatLoaded.value ? TimeLineScreen() : SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class HomeController extends GetxController with WidgetsBindingObserver {
  final accessToken = Rx<String?>(null);
  final sdkInitCompleted = false.obs;
  final Rx<ChatSession?> chatSession = Rx(null);
  final Rx<String?> chatRoomId = Rx(null);
  final chatLoaded = false.obs;
  late EngagementSDK sdk;

  @override
  void onReady() async {
    super.onReady();
    final sharedPref = await Get.putAsync(() => SharedPreferences.getInstance(),
        permanent: true);

    sdk = Get.put<EngagementSDK>(
        EngagementSDK.accessToken("8PqSNDgIVHnXuJuGte1HdvOjOqhCFE1ZCR3qhqaS",
            sharedPref.getString("accessToken"), (event) async {
          print("Access Token: $event");
          await sharedPref.setString("accessToken", event);
          accessToken.value = event;
          sdkInitCompleted.value = true;
        }),
        permanent: true);

    sdkInitCompleted.addListener(GetStream(onListen: () {
      if (sdkInitCompleted.value == true) {
        createChatSession();
        return;
      }
      accessToken.value = sharedPref.getString("accessToken");
      if (accessToken.value?.isNotEmpty == true) {
        createChatSession();
      }
    }));

    sdk.errorStream.listen((error) {
      print("Error: $error");
      sdkInitCompleted.value = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("LifeCycle : $state");
    switch (state) {
      case AppLifecycleState.resumed:
        chatSession.value?.resume();
        break;
      case AppLifecycleState.paused:
        chatSession.value?.pause();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void createChatSession() async {
    final id = "812b63c4-c8bb-4133-9fab-e6111cc4bf27";
    if (id != null && id.isNotEmpty) {
      chatSession.value = await sdk.createChatSession(id);
      chatLoaded.value = true;
    } else {
      showErrorMessage("Please Enter Valid ChatRoom ID");
    }
  }

  void showErrorMessage(String message) {
    Get.snackbar("Error", message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void showSuccessMessage(String message) {
    Get.snackbar("Success", message,
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
