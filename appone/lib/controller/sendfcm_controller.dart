import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:get/get.dart";

import "../constants/constans.dart";

class SendFCM extends GetxController {
  Future<bool> sendFcmMessage(String title, String message) async {
    try {
      var url = "https://fcm.googleapis.com/fcm/send";
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key=$serverKey",
      };
      var request = {
        "notification": {
          "title": title,
          "body": message,
        },
        "android": {
          "notification": {
            "sound": "notification",
            "channel_id": "alert_notification",
          }
        },
        "priority": "high",
        "data": <String, dynamic>{
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done",
          "type": "alert",
        },
        "to": "/topics/topic"
      };

      var client = http.Client();
      var response = await client.post(Uri.parse(url),
          headers: header, body: json.encode(request));
      debugPrint("done........ ${response.statusCode}");
      debugPrint("done........ ${response}");
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
