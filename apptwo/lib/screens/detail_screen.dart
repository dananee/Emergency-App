import 'package:apptwo/constants/routes_name.dart';
import 'package:apptwo/help/validators.dart';
import 'package:apptwo/model/user_model.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key});

  final UserModel data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff313340),
      appBar: AppBar(
        backgroundColor: const Color(0xff313340),
        elevation: 0.0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
            tileMode: TileMode.decal,
            colors: [Color.fromARGB(255, 252, 228, 215), Color(0xffF2A71B)],
          ).createShader(bounds),
          child: Text("User Alerts Infos",
              style: TextStyle(
                  fontSize: 25.sp,
                  color: const Color(0xffF2A71B),
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0.w, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                "Full Name",
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 204, 201, 201),
                  fontSize: 18.sp,
                ),
              ),
              Text(
                data.fullName!.capitalize(),
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 244, 244, 244),
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Email address",
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 204, 201, 201),
                  fontSize: 18.sp,
                ),
              ),
              Text(
                data.email!,
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 244, 244, 244),
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Phone number",
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 204, 201, 201),
                  fontSize: 18.sp,
                ),
              ),
              Text(
                data.phone!,
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 244, 244, 244),
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Send Date and Time",
                style: GoogleFonts.cairo(
                  color: const Color.fromARGB(255, 204, 201, 201),
                  fontSize: 18.sp,
                ),
              ),
              Text(
                Jiffy.parseFromMicrosecondsSinceEpoch(
                        data.sendDatetime!.microsecondsSinceEpoch)
                    .format(pattern: 'dd-MM-yyyy HH:mm:ss'),
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 244, 244, 244),
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color.fromARGB(255, 72, 73, 81),
                  ),
                  child: ExpansionTileCard(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color.fromARGB(255, 204, 201, 201),
                    ),
                    expandedColor: const Color.fromARGB(255, 36, 36, 36),
                    baseColor: const Color.fromARGB(255, 72, 73, 81),
                    title: Text(
                      data.connectionInfos!.ssid!,
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 244, 244, 244),
                        fontSize: 18.sp,
                      ),
                    ),
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                        child: Text(
                          'Connection Type:',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Text(
                        data.connectionInfos!.connectionType!,
                        style: GoogleFonts.lato(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                        child: Text(
                          'IP Address:',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Text(
                        data.connectionInfos!.ip!,
                        style: GoogleFonts.lato(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0.h),
                        child: Text(
                          'MAC Address:',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      Text(
                        data.connectionInfos!.mac!,
                        style: GoogleFonts.lato(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  )),
              SizedBox(
                height: 40.h,
              ),
              Visibility(
                visible: data.lastSmsMsg!.isNotEmpty && data.lastSmsMsg != null,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  onTap: () {
                    Get.toNamed(AppRoute.listdatasms,
                        arguments: data.lastSmsMsg);
                  },
                  tileColor: const Color.fromARGB(255, 72, 73, 81),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 204, 201, 201),
                  ),
                  title: Text(
                    "SMS Messages List",
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Visibility(
                visible: data.lastPhoneCall!.isNotEmpty &&
                    data.lastPhoneCall != null,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onTap: () {
                    Get.toNamed(AppRoute.listdatacall,
                        arguments: data.lastPhoneCall);
                  },
                  tileColor: const Color.fromARGB(255, 72, 73, 81),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color.fromARGB(255, 204, 201, 201),
                  ),
                  title: Text(
                    "Last Phone Calls List",
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
