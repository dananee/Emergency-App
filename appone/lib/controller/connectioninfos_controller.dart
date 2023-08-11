import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class ConnectionInfosController extends GetxController {
  @override
  void onInit() {
    initPlatformState();
    super.onInit();
  }

  Future<WifiInfoWrapper?> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
    } on PlatformException {
      debugPrint('Connection Infos Error: ');
    }
    // if (!mounted) return;

    return wifiObject;
  }
}
