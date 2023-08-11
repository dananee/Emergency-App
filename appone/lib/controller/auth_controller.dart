import 'package:appone/constants/routes_name.dart';
import 'package:appone/controller/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late User? user;

  final profileController = Get.put(ProfileController());
 

  isExsist() async {
    print('ISLOGGED  - ${isLogin()}');
    if (isLogin() == true) {
      bool isExists = await profileController.isExists();
      if (isExists == false) {
        Get.offAllNamed(AppRoute.home);
      } else if (isExists == true) {
        
        Get.offAllNamed(AppRoute.profile, arguments: true);
      }
    } else {
      Get.offAllNamed(AppRoute.login);
    }
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLogin();
      Future.delayed(const Duration(seconds: 3), () {
        isExsist();
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
      await profileController.isExists()
          ? Get.offNamed(AppRoute.profile, arguments: true)
          : Get.offNamed(AppRoute.home);
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
