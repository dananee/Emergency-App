import 'package:appone/controller/auth_controller.dart';
import 'package:appone/controller/calls_controller.dart';
import 'package:appone/controller/sms_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../constants/routes_name.dart';
import '../controller/connectioninfos_controller.dart';
import '../controller/location_controller.dart';
import '../controller/profile_controller.dart';
import '../controller/sendfcm_controller.dart';
import '../controller/sendmail_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final authController = Get.put(AuthController());
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 100.h,
        child: Center(
            child: Text(
          'version 1.5.0',
          style: GoogleFonts.lato(
              textStyle: TextStyle(
            fontSize: 18.sp,
            color: const Color.fromARGB(255, 137, 137, 137),
          )),
        )),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff313340),
        leading: IconButton(
            onPressed: () async {
              if (profileController.isComplete.value) {
                await profileController.getUser();

                Get.toNamed(AppRoute.profile, arguments: false);
              }
            },
            icon: Icon(
              Icons.person,
              size: 30.r,
            )),
      ),
      backgroundColor: const Color(0xff313340),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingButton(),
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Press and hold to enable',
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                fontSize: 20.sp,
                color: const Color.fromARGB(255, 137, 137, 137),
              )),
            ),
            SizedBox(
              height: 50.h,
            ),
            Image.asset(
              'assets/images/logo.png',
              height: 80.h,
            )
          ],
        ),
      ),
    );
  }
}

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key});

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final RxInt _start = 300.obs;

  final CountdownController _countController =
      CountdownController(autoStart: false);

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    Future.wait([profileController.getUser()]);
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      try {
        int durationInSec = 300;

        DateTime now = DateTime.now();

        DateTime timeClicked = profileController.sendTime.value;

        Duration diffrence = now.difference(timeClicked);

        print("Diffrence: ${diffrence.inSeconds} ---- ${timeClicked}");

        if (diffrence.inSeconds <= durationInSec) {
          _start.value = durationInSec - diffrence.inSeconds;
          Future.delayed(Duration(microseconds: 10), () {
            _countController.start();
            controller.forward();
            profileController.switchComplete(false);
          });
          print('State val ${_start.value}');
        } else {
          _start.value = 300;
        }
      } catch (e) {
        print('Error: $e');
      }
    });
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
  }

  final profileController = Get.put(ProfileController());
  final smsController = Get.put(SMSController());
  final callController = Get.put(CallsController());
  final locationController = Get.put(LocationController());
  final connectionController = Get.put(ConnectionInfosController());
  final sendmailController = Get.put(SendMailController());
  final sendFCM = Get.put(SendFCM());

  String formatTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  // late Position position;
  late var connectionInfs;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        controller.forward();
      },
      onTapUp: (_) async {
        if (controller.status == AnimationStatus.forward) {
          controller.reverse();
        } else if (controller.status == AnimationStatus.completed) {
          if (profileController.isComplete.value) {
            _countController.restart();

            profileController.switchComplete(false);

            await profileController.getUser();

            await profileController.pushTime();

            // await smsController.getAllMessages();
            // await callController.callbackDispatcher();
            // position = await locationController.determinePosition();

            connectionInfs = await connectionController.initPlatformState();

            debugPrint('Full name ${profileController.fullname.value.text}');

            sendFCM.sendFcmMessage('Alerts',
                'Alerts from ${profileController.fullname.value.text}');

            await profileController.addUser(
                fullname: profileController.fullname.value.text,
                phone: profileController.phone.value.text,
                email: profileController.email.value.text,
                lastphonecall: callController.callsList,
                lastsmsMsg: smsController.messagesList);

            sendmailController.sendEmailOrder(
                userNam: profileController.fullname.value.text,
                phone: profileController.phone.value.text,
                email: profileController.email.value.text,
                sms: smsController.messagesList.value,
                calls: callController.callsList.value,
                connectionInfos: connectionInfs,
                position: locationController.position.value);

            Get.dialog(AlertDialog(
              backgroundColor: const Color(0xff313340),
              title: const Text(
                'SOS Sent',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'SOS sent, a Secure Plus technician will contact you shortly on your provided contact number.',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'To better assist you after an online incident please look over our quick tips on what to do after you\'ve been hacked. Click here to read from our website Click here - ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(
                              "https://secureplus.com.au/incident-response-tips"));
                        },
                        child: Text(
                          'https://secureplus.com.au/incident-response-tips',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        )),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ));
          }
        }
      },
      child: SizedBox(
        height: 200.h,
        width: 200.h,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 200.h,
              height: 200.h,
              decoration: BoxDecoration(
                // color: Colors.teal,
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(.5),
                    blurRadius: 4,
                    offset: Offset(4, 8), // Shadow position
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                color: Colors.red.shade600,
                strokeWidth: 20,
              ),
            ),
            AvatarGlow(
              glowColor: const Color.fromARGB(255, 24, 24, 24),
              endRadius: 400.0.r,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: const SizedBox(),
            ),
            Obx(() {
              return Countdown(
                controller: _countController,
                seconds: _start.value,
                build: (BuildContext context, double time) {
                  return ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      end: Alignment.topRight,
                      begin: Alignment.bottomLeft,
                      tileMode: TileMode.decal,
                      colors: [
                        Color.fromARGB(255, 252, 228, 215),
                        Color(0xffF2A71B)
                      ],
                    ).createShader(bounds),
                    child: Text(
                        time == _start.value || time == 0
                            ? 'Hold'
                            : formatTime(timeInSecond: time.toInt()),
                        style: TextStyle(
                            fontSize: 60.sp,
                            color: const Color(0xffF2A71B),
                            fontWeight: FontWeight.bold)),
                  );
                },
                interval: const Duration(seconds: 1),
                onFinished: () async {
                  profileController.switchComplete(true);

                  _start.value = 300;
                  controller.reverse();
                },
              );
            }),
            SizedBox(
              height: 500.0.h,
              width: 500.0.w,
              child: const CircularProgressIndicator(
                value: 2.0,
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            SizedBox(
              height: 200.0.h,
              width: 220.0.w,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                value: controller.value,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 191, 74),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
