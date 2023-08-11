import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName;
  String? phone;
  String? email;
  double? lat;
  double? long;
  Timestamp? sendDatetime;

  ConnectionInfos? connectionInfos;
  List<LastPhoneCall>? lastPhoneCall;
  List<LastSmsMsg>? lastSmsMsg;

  UserModel(
      {this.fullName,
      this.phone,
      this.email,
      this.lat,
      this.sendDatetime,
      this.long,
      this.connectionInfos,
      this.lastPhoneCall,
      this.lastSmsMsg});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    sendDatetime = json['send_dateime'];
    lat = json['lat'];
    long = json['long'];
    connectionInfos = json['connection_infos'] != null
        ? ConnectionInfos.fromJson(json['connection_infos'])
        : null;
    if (json['last_phone_call'] != null) {
      lastPhoneCall = <LastPhoneCall>[];
      json['last_phone_call'].forEach((v) {
        lastPhoneCall!.add(LastPhoneCall.fromJson(v));
      });
    }
    if (json['last_sms_msg'] != null) {
      lastSmsMsg = <LastSmsMsg>[];
      json['last_sms_msg'].forEach((v) {
        lastSmsMsg!.add(LastSmsMsg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['email'] = email;
    data['send_dateime'] = sendDatetime;
    data['lat'] = lat;
    data['long'] = long;
    if (connectionInfos != null) {
      data['connection_infos'] = connectionInfos!.toJson();
    }
    if (lastPhoneCall != null) {
      data['last_phone_call'] = lastPhoneCall!.map((v) => v.toJson()).toList();
    }
    if (lastSmsMsg != null) {
      data['last_sms_msg'] = lastSmsMsg!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConnectionInfos {
  String? ssid;
  String? mac;
  String? connectionType;
  String? ip;

  ConnectionInfos({this.ssid, this.mac, this.connectionType, this.ip});

  ConnectionInfos.fromJson(Map<String, dynamic> json) {
    ssid = json['ssid'];
    mac = json['mac'];
    connectionType = json['connection_type'];
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ssid'] = ssid;
    data['mac'] = mac;
    data['connection_type'] = connectionType;
    data['ip'] = ip;
    return data;
  }
}

class LastPhoneCall {
  String? phoneNumber;
  String? name;
  String? callType;
  String? simName;
  int? timestamp;
  int? duration;

  LastPhoneCall(
      {this.phoneNumber,
      this.name,
      this.callType,
      this.simName,
      this.timestamp,
      this.duration});

  LastPhoneCall.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    name = json['name'];
    callType = json['call_type'];
    simName = json['sim_name'];
    timestamp = json['timestamp'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = phoneNumber;
    data['name'] = name;
    data['call_type'] = callType;
    data['sim_name'] = simName;
    data['timestamp'] = timestamp;
    data['duration'] = duration;
    return data;
  }
}

class LastSmsMsg {
  String? address;
  String? body;
  String? date;

  LastSmsMsg({this.address, this.body, this.date});

  LastSmsMsg.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    body = json['body'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = address;
    data['body'] = body;
    data['date'] = date;
    return data;
  }
}
