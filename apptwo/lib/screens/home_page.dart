import 'package:apptwo/constants/routes_name.dart';
import 'package:apptwo/controller/auth_controller.dart';
import 'package:apptwo/controller/data_controller.dart';
import 'package:apptwo/help/validators.dart';
import 'package:apptwo/model/user_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
// import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final authController = Get.put(AuthController());
  final dataController = Get.put(DataController());

  Future getLocation() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(52.2165157, 6.9437819);
    print(placemarks.first.country);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff313340),
        actions: [
          IconButton(
              onPressed: () async {
                Get.toNamed(AppRoute.profile);
              },
              icon: Icon(
                Icons.person,
                size: 30.r,
              )),
        ],
      ),
      backgroundColor: const Color(0xff313340),
      body: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    end: Alignment.topRight,
                    begin: Alignment.bottomLeft,
                    tileMode: TileMode.decal,
                    colors: [
                      Color.fromARGB(255, 255, 186, 205),
                      Color.fromARGB(255, 254, 54, 147)
                    ],
                  ).createShader(bounds),
                  child: Text("Incoming\nAlerts",
                      style: TextStyle(
                          fontSize: 40.sp,
                          color: const Color(0xffF2A71B),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: StreamBuilder<QuerySnapshot<UserModel>>(
                stream: dataController.getUser(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "There is ${snapshot.data!.docs.length} alerts",
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 133, 133, 133),
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data();
                            final datetime =
                                Jiffy.parseFromMicrosecondsSinceEpoch(data
                                        .sendDatetime!.microsecondsSinceEpoch)
                                    .fromNow();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Text(
                                    data.fullName!.capitalize(),
                                    style: GoogleFonts.lato(
                                        color: Colors.white, fontSize: 20.sp),
                                  ),
                                  trailing: Text(
                                    datetime,
                                    style: GoogleFonts.lato(
                                      color: const Color.fromARGB(
                                          255, 133, 133, 133),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  onTap: () async {
                                    // await getLocation();
                                    Get.toNamed(
                                      AppRoute.details,
                                      arguments: data,
                                    );
                                  },
                                ),
                                const Divider(
                                  indent: 15,
                                  endIndent: 15,
                                  thickness: 0.1,
                                  color: Color.fromARGB(255, 134, 134, 134),
                                )
                              ],
                            );
                          }),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
