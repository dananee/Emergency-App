import 'package:app_settings/app_settings.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CallsController extends GetxController {
  RxList<Map<String, dynamic>> callsList =
      (List<Map<String, dynamic>>.of([])).obs;

  @override
  void onInit() {
    callbackDispatcher();
    super.onInit();
  }

  Future callbackDispatcher() async {
    var phonePermission = await Permission.phone.request();

    Iterable<CallLogEntry> entries = await CallLog.get();
    List<CallLogEntry> calls = entries.toList();

    callsList.clear();

    for (var element = 0; element < 10; element++) {
      callsList.add({
        "phone_number": calls[element].number,
        "name": calls[element].name,
        "call_type": calls[element].callType!.toString(),
        "duration": calls[element].duration,
        "timestamp": calls[element].timestamp,
        "sim_name": calls[element].simDisplayName
      });
    }
    update();

    debugPrint(
        'CALLS ${calls.length} ${callsList.length} ${await Permission.phone.status}');

    try {
      if (phonePermission == Permission.phone.isDenied) {
        phonePermission = await Permission.phone.request();

        if (phonePermission == Permission.phone.isPermanentlyDenied) {
          Get.dialog(AlertDialog(
            title: Text('Call permissions are permanently denied'),
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
              'Calls permissions are permanently denied, we cannot request permissions.');
        }
      }

      if (phonePermission == Permission.phone.isPermanentlyDenied) {
        Get.dialog(AlertDialog(
          title: Text('Call permissions are permanently denied'),
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
            'Call permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      debugPrint('ERROR CALLS ${e}');
    }
  }
}
