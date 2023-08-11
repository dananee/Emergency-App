import 'package:apptwo/constants/routes_name.dart';
import 'package:apptwo/controller/binding/auth_binding.dart';
import 'package:apptwo/controller/local_notif.dart';
import 'package:apptwo/firebase_options.dart';
import 'package:apptwo/screens/detail_screen.dart';
import 'package:apptwo/screens/home_page.dart';
import 'package:apptwo/screens/listofdataSMS_screen.dart';
import 'package:apptwo/screens/login_page.dart';
import 'package:apptwo/screens/profile_screen.dart';
import 'package:apptwo/screens/startscreen_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart'
    as ntf;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'screens/listofdataCall_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// "${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"
// /usr/lib/swift

Future<void> initialFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  await LocalNotif.initialize(flutterLocalNotificationsPlugin);
  await FirebaseMessaging.instance.subscribeToTopic("topic");
  // debugPrint('\nNotification Channel Result: $result');
}

Future<void> subscribeToTopic() async {
  try {
    await FirebaseMessaging.instance.subscribeToTopic('topic');
  } catch (e) {
    debugPrint('error is $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialFirebase();
  await subscribeToTopic();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAnalytics.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint(await messaging.getToken());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    initializeFCM();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  initializeFCM() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    await FirebaseMessaging.instance.subscribeToTopic("topic");

    if (initialMessage != null) {
      for (var item in initialMessage.data.values) {
        debugPrint('on Message Opened App $item ');
      }
      _handleNotification(initialMessage.data);
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((event) async {
      debugPrint('on Message App  => ${event.notification!.body} ');
      // Get.snackbar(event.notification!.title!, event.notification!.body!,
      //     backgroundColor: Colors.white);

      await flutterLocalNotificationsPlugin.show(
        event.data.length,
        event.notification!.title,
        event.notification!.body,
        await LocalNotif.notificationdetails(),
      );
      Future.value(() {
        AssetsAudioPlayer.newPlayer().open(
          Audio("assets/audio/alert.wav"),
          autoStart: true,
          showNotification: true,
        );
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      // print('on Message Opened App ${event.notification!.body!} ');

      debugPrint('on Message Opened App ${event.notification!.body!} ');

      _handleNotification(event.data);
    });
  }

  void _handleNotification(Map<String, dynamic> message) {
    /// right now we only handle click actions on chat messages only

    try {
      if (message['type'] == "alert") {
        Future.delayed(const Duration(seconds: 0), () => Get.to(AppRoute.home));
      }
    } catch (e, _) {
      //NO-OP
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Secure Plus',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            initialBinding: AuthBinding(),
            getPages: [
              GetPage(
                  name: AppRoute.satrtscreen,
                  page: () => StartScreen(),
                  binding: AuthBinding(),
                  transition: Transition.zoom),
              GetPage(
                  name: AppRoute.login,
                  page: () => LoginPage(),
                  transition: Transition.zoom),
              GetPage(
                  name: AppRoute.home,
                  page: () => HomePage(),
                  transition: Transition.zoom),
              GetPage(
                  name: AppRoute.details,
                  page: () => DetailScreen(),
                  transition: Transition.zoom),
              GetPage(
                  name: AppRoute.listdatasms,
                  page: () => ListDataSMS(),
                  transition: Transition.cupertino),
              GetPage(
                  name: AppRoute.listdatacall,
                  page: () => ListDataCall(),
                  transition: Transition.cupertino),
              GetPage(
                  name: AppRoute.profile,
                  page: () => ProfileScreen(),
                  // binding: ProfileScreen(),
                  transition: Transition.circularReveal),
            ],
            home: StartScreen(),
          );
        });
  }
}
