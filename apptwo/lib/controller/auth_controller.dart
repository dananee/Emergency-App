import 'package:apptwo/constants/routes_name.dart';
import 'package:apptwo/controller/checkadmin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late User? user;

  final checkAdmin = Get.put(CheckAdmin());

  isExsist(email) async {
    bool isadmin = await checkAdmin.isAdmin(email: email);

    if (isLogin() && isadmin) {
      Get.offAllNamed(AppRoute.home);
    } else {
      Get.offAllNamed(AppRoute.login);
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLogin();
      Future.delayed(const Duration(seconds: 3), () {
        try {
          String email = FirebaseAuth.instance.currentUser!.email ?? "";

          isExsist(email);
        } catch (e) {
          Get.offAllNamed(AppRoute.login);
        }
      });
    });
    super.onInit();
  }

  Future<User?> signInUsingEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      user = userCredential.user;
      bool isAdmin = false;
      isAdmin = await checkAdmin.isAdmin(email: email);
      if (isAdmin) {
        Get.offNamed(AppRoute.home, arguments: true);
      } else {
        (Get.snackbar('Not Authorized', "You're not allowed ",
            backgroundColor: Colors.white));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Warning!", "You do not have an account",
            backgroundColor: Colors.white);
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Warning!", "Wrong password provided for that user",
            duration: const Duration(seconds: 5),
            isDismissible: true,
            backgroundColor: Colors.white);
      }
    }
    return user;
  }

  Future signout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoute.login);
  }

  bool isLogin() {
    bool isLogged = false;

    if (FirebaseAuth.instance.currentUser != null) {
      isLogged = true;
    } else {
      isLogged = false;
    }

    return isLogged;
  }
}
