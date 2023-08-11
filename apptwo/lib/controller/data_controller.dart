import 'package:apptwo/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users_data');

  Stream<QuerySnapshot<UserModel>> getUser() async* {
    try {
      final data = users.withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );
      data.get().then(
          (vale) => debugPrint(vale.docs.first.data().sendDatetime.toString()));
      yield* data
          .orderBy("send_dateime", descending: true)
          .limit(20)
          .snapshots();
      // update();
    } catch (e) {
      debugPrint("Failed to GETIING user: $e");
    }
  }
}
