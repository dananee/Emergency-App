import 'package:apptwo/help/validators.dart';
import 'package:apptwo/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final _validate = AutovalidateMode.disabled.obs;

  final GlobalKey<FormState> _key = GlobalKey();

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff313340),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _key,
          autovalidateMode: _validate.value,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0.h, right: 10.0.w, left: 10.0.w, bottom: 10.h),
                  child: Center(
                      child: Image.asset(
                    "assets/images/logo-1.png",
                    height: 220.h,
                  )),
                ),
                LabelForm(
                  textColor: Colors.white,
                  text: "Email Address".tr,
                ),
                LoginFormInput(
                  textColor: Colors.white,
                  controller: _emailController,
                  validate: validateEmail,
                  keyBoardType: TextInputType.emailAddress,
                  borderColor: Colors.white,
                ),
                SizedBox(
                  height: 20.h,
                ),
                LabelForm(
                  textColor: Colors.white,
                  text: "Password".tr,
                ),
                LoginFormInput(
                  textColor: Colors.white,
                  controller: _passwordController,
                  validate: validatePassword,
                  isPassword: true,
                  keyBoardType: TextInputType.visiblePassword,
                  borderColor: Colors.white,
                  focusColor: Colors.white,
                  focusedColor: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0.r),
                                side: const BorderSide(color: Colors.white)))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0.h),
                      child: Text(
                        'Sign In'.tr,
                        style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900),
                      ),
                    ),
                    onPressed: () async {
                      if (_key.currentState?.validate() ?? false) {
                        _key.currentState!.save();

                        await authController.signInUsingEmailPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim());
                      } else {
                        _validate.value = AutovalidateMode.onUserInteraction;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Click here to request registration",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xff97a8eb),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
