import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  @override
  void onInit() {
    determinePosition();
    super.onInit();
  }

  Rx<Position> position = (Position(
    latitude: 0.0,
    longitude: 0.0,
    accuracy: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
    timestamp: DateTime.now(),
  )).obs;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      debugPrint('LocationPermission');
      position.value = await Geolocator.getCurrentPosition();
      update();
    }

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.dialog(AlertDialog(
          backgroundColor: const Color(0xff313340),
          title: const Text(
            'Location service is disbaled',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Please turn on the location to continue',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ));

        return Future.error('Location services are disabled.');
      }

      print('position ${position.value}');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          Get.dialog(AlertDialog(
            title: Text('Location permissions are permanently denied'),
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
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.dialog(AlertDialog(
          title: Text('Location permissions are permanently denied'),
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
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    } catch (e) {
      debugPrint('LOCATION ERROR : $e');
    }
  }
}
