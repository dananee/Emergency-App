import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class CheckAdmin extends GetxController {
  CollectionReference<Map<String, dynamic>> admin =
      FirebaseFirestore.instance.collection('admin_user');

  Future<bool> isAdmin({String? email}) async {
    final snapShot = await admin.doc("fU6iWL1R4co4nkvBrwWj").get();

    if (snapShot.get("list_email").contains(email)) {
      return true;
    } else {
      return false;
    }
  }
}
