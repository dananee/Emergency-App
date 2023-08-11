import 'package:apptwo/model/user_model.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class ListDataCall extends StatelessWidget {
  ListDataCall({super.key});

  final List<LastPhoneCall>? listData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff313340),
      appBar: AppBar(
        backgroundColor: const Color(0xff313340),
        elevation: 0.0,
        title: const Text("Last Calls List"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: listData!.length,
          itemBuilder: ((context, index) {
            final msg = listData![index];
            return SizedBox(
              child: ExpansionTileCard(
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                expandedColor: const Color.fromARGB(255, 36, 36, 36),
                baseColor: const Color(0xff313340),
                title: msg.name != null
                    ? Text(
                        msg.name!,
                        style: GoogleFonts.lato(
                          color: const Color.fromARGB(255, 244, 244, 244),
                          fontSize: 18.sp,
                        ),
                      )
                    : Text(
                        'No Name',
                        style: GoogleFonts.lato(
                          color: const Color.fromARGB(255, 132, 132, 132),
                          fontSize: 18.sp,
                        ),
                      ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Text(
                      'Phone Number',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 132, 132, 132),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  msg.timestamp != null
                      ? Text(
                          msg.phoneNumber!,
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 244, 244, 244),
                            fontSize: 18.sp,
                          ),
                        )
                      : Text(
                          'none',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Text(
                      'Calling datetime',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 132, 132, 132),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  msg.timestamp != null
                      ? Text(
                          Jiffy.parseFromMicrosecondsSinceEpoch(msg.timestamp!)
                              .format(pattern: 'dd-MM-yyyy HH:mm:ss'),
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 244, 244, 244),
                            fontSize: 18.sp,
                          ),
                        )
                      : Text(
                          'none',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Text(
                      'Calling duration',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 132, 132, 132),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  msg.duration != null
                      ? Text(
                          '${msg.duration!} seconds',
                          style: GoogleFonts.lato(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18.sp,
                          ),
                        )
                      : Text(
                          'none',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Text(
                      'Call Type',
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 132, 132, 132),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  msg.callType != null
                      ? Text(
                          msg.callType!,
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18.sp,
                          ),
                        )
                      : Text(
                          'none',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0.h),
                    child: Text(
                      'SIM',
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 132, 132, 132),
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  msg.simName != null
                      ? Text(
                          msg.simName!,
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18.sp,
                          ),
                        )
                      : Text(
                          'none',
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 132, 132, 132),
                            fontSize: 18.sp,
                          ),
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          })),
    );
  }
}
