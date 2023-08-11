import 'package:apptwo/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StartScreen extends StatelessWidget {
  StartScreen({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff313340),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.h,
                child: Image.asset("assets/images/logo-1.png"),
              ),
              SizedBox(
                height: 80.h,
              ),
              CircularProgressIndicator(
                color: Color(0xffD92B5A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
