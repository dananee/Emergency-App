import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

class SMSController extends GetxController {
  final Telephony telephony = Telephony.instance;
  // RxString _message = "".obs;

  RxList<Map<String, dynamic>> messagesList =
      (List<Map<String, dynamic>>.of([])).obs;

  @override
  void onInit() {
    // initPlatformState();
    super.onInit();
  }

  Future getAllMessages() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    print('SMS PERMISSION ${permissionsGranted!}');
    if (permissionsGranted) {
      List<SmsMessage> messages = await telephony.getInboxSms(columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY
      ], sortOrder: [
        OrderBy(SmsColumn.DATE_SENT, sort: Sort.DESC),
        // OrderBy(SmsColumn.BODY)
      ]);

      messagesList.clear();
      print(messages.length);
      for (var element = 0; element < 10; element++) {
        messagesList.add({
          "address": messages[element].address,
          "body": messages[element].body,
          "date": messages[element].date
        });
      }
      update();
    } else {
      await telephony.requestPhoneAndSmsPermissions;
      var permission = await Permission.sms.request();
      if (permission == Permission.sms.isPermanentlyDenied) {
        Get.dialog(AlertDialog(
          title: Text('SMS permissions are permanently denied'),
          actions: [
            TextButton(
                onPressed: () async {
                  await AppSettings.openAppSettings();
                },
                child: Text('Allow permission on setting')),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('cancel')),
          ],
        ));
        return Future.error('SMS permissions are denied');
      }
    }
    try {
      if (Permission.sms.status == Permission.sms.isPermanentlyDenied) {
        Get.dialog(AlertDialog(
          title: Text('SMS permissions are permanently denied'),
          actions: [
            TextButton(
                onPressed: () async {
                  await AppSettings.openAppSettings();
                },
                child: Text('Allow permission on setting')),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('cancel')),
          ],
        ));
        return Future.error(
            'SMS permissions are permanently denied, we cannot request permissions.');
      }

      // print(messagesList);
      // print(messagesList.length);
    } catch (e) {
      debugPrint('Error Message SMS $e');
    }
  }

  // onMessage(SmsMessage message) async {
  //   _message.value = message.body ?? "Error reading message body.";
  // }

  // onBackgroundMessage(SmsMessage message) {
  //   debugPrint("onBackgroundMessage called");
  // }

  // Future<void> initPlatformState() async {
  //   final bool? result = await telephony.requestPhoneAndSmsPermissions;

  //   if (result != null && result) {
  //     telephony.listenIncomingSms(
  //         onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
  //   }
  // }
}
