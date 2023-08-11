import 'package:appone/constants/routes_name.dart';
import 'package:appone/controller/binding/auth_binding.dart';
import 'package:appone/controller/countdown_controller.dart';
import 'package:appone/firebase_options.dart';
import 'package:appone/screens/home_page.dart';
import 'package:appone/screens/login_page.dart';
import 'package:appone/screens/profile_page.dart';
import 'package:appone/screens/startscreen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controller/binding/profile_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');
  // This widget is the root of your application.
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
                  name: AppRoute.profile,
                  page: () => const ProfilePage(),
                  binding: ProfileBinding(),
                  transition: Transition.zoom),
            ],
            home: StartScreen(),
          );
        });
  }
}
