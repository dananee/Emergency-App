import 'package:appone/controller/auth_controller.dart';
import 'package:appone/controller/calls_controller.dart';
import 'package:appone/controller/profile_controller.dart';
import 'package:appone/controller/sms_controller.dart';
import 'package:appone/help/validators.dart';
import 'package:appone/screens/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/routes_name.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final GlobalKey<FormState> _key = GlobalKey();
  final _validate = AutovalidateMode.disabled.obs;

  final authController = Get.put(AuthController());

  final GlobalKey<FormState> _key = GlobalKey();

  final profileController = Get.put(ProfileController());
  final smsController = Get.put(SMSController());
  final callController = Get.put(CallsController());

  @override
  void dispose() {
    profileController.fullname.value.clear();
    profileController.phone.value.clear();
    profileController.email.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff313340),
      ),
      backgroundColor: const Color(0xff313340),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Form(
          key: _key,
          autovalidateMode: _validate.value,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 32.0.h, right: 16.0.w, left: 16.0.w, bottom: 50.h),
                  child: Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                LabelForm(
                  textColor: Colors.white,
                  text: "Full name".tr,
                ),
                LoginFormInput(
                  textColor: Colors.white,
                  controller: profileController.fullname.value,
                  validate: validateEmptyFieldD,
                  keyBoardType: TextInputType.name,
                  borderColor: Colors.white,
                ),
                SizedBox(
                  height: 10.h,
                ),
                LabelForm(
                  textColor: Colors.white,
                  text: "Email".tr,
                ),
                LoginFormInput(
                  textColor: Colors.white,
                  controller: profileController.email.value,
                  validate: validateEmail,
                  keyBoardType: TextInputType.emailAddress,
                  borderColor: Colors.white,
                ),
                SizedBox(
                  height: 10.h,
                ),
                LabelForm(
                  textColor: Colors.white,
                  text: "Phone Number".tr,
                ),
                LoginFormInput(
                  textColor: Colors.white,
                  controller: profileController.phone.value,
                  validate: validateMobile,
                  keyBoardType: TextInputType.phone,
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
                        Get.arguments ? 'Save' : 'Update',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900),
                      ),
                    ),
                    onPressed: () async {
                      // await smsController.getAllMessages();
                      // await callController.callbackDispatcher();
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_key.currentState?.validate() ?? false) {
                        _key.currentState!.save();

                        profileController.addUser(
                            fullname: profileController.fullname.value.text,
                            email: profileController.email.value.text,
                            phone: profileController.phone.value.text,
                            lastphonecall: callController.callsList.value,
                            lastsmsMsg: smsController.messagesList.value);
                      }
                      // profileController.getUser();
                    },
                  ),
                ),
                Visibility(
                  visible: !Get.arguments,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 255, 48, 48)),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 6, 6, 6))))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0.h),
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      onPressed: () async {
                        await authController.signout();
                        Get.offNamed(AppRoute.login);
                      },
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
