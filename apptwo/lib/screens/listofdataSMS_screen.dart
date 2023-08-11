import 'package:apptwo/model/user_model.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

class ListDataSMS extends StatelessWidget {
  ListDataSMS({super.key});

  final List<LastSmsMsg>? listData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff313340),
      appBar: AppBar(
        backgroundColor: const Color(0xff313340),
        elevation: 0.0,
        title: const Text("SMS List Messages"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: listData!.length,
          itemBuilder: ((context, index) {
            final msg = listData![index];
            return SizedBox(
              child: ExpansionTileCard(
                  expandedColor: const Color.fromARGB(255, 36, 36, 36),
                  baseColor: const Color(0xff313340),
                  title: Text(
                    msg.address!,
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 244, 244, 244),
                      fontSize: 18.sp,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: Text(
                        msg.body!,
                        style: GoogleFonts.lato(
                          color: const Color.fromARGB(255, 244, 244, 244),
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ]),
            );
          })),
    );
  }
}
