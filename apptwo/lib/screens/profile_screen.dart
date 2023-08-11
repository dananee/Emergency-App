import 'package:apptwo/controller/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final authController = Get.put(AuthController());
  final email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff313340),
      appBar: AppBar(
        backgroundColor: const Color(0xff313340),
        title: const Text('Profile'),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              email!,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Color.fromARGB(255, 245, 245, 244),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60.h,
            ),
            Container(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                          horizontal: 80.w, vertical: 13.h)),
                  onPressed: () async {
                    await authController.signout();
                  },
                  child: Text('Sign out')),
            ),
          ],
        ),
      ),
    );
  }
}
