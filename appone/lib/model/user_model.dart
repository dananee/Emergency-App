import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName;
  String? phone;
  String? email;
  double? lat;
  double? long;
  ConnectionInfos? connectionInfos;
  List<LastPhoneCall>? lastPhoneCall;
  List<LastSmsMsg>? lastSmsMsg;
  Timestamp? sendTime;

  UserModel({
    this.fullName,
    this.phone,
    this.email,
    this.lat,
    this.long,
    this.connectionInfos,
    this.lastPhoneCall,
    this.lastSmsMsg,
    this.sendTime,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    lat = json['lat'];
    long = json['long'];
    sendTime = json['push_time'];
    connectionInfos = json['connection_infos'] != null
        ? new ConnectionInfos.fromJson(json['connection_infos'])
        : null;
    if (json['last_phone_call'] != null) {
      lastPhoneCall = <LastPhoneCall>[];
      json['last_phone_call'].forEach((v) {
        lastPhoneCall!.add(new LastPhoneCall.fromJson(v));
      });
    }
    if (json['last_sms_msg'] != null) {
      lastSmsMsg = <LastSmsMsg>[];
      json['last_sms_msg'].forEach((v) {
        lastSmsMsg!.add(new LastSmsMsg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['lat'] = this.lat;
    data['long'] = this.long;
    if (this.connectionInfos != null) {
      data['connection_infos'] = this.connectionInfos!.toJson();
    }
    if (this.lastPhoneCall != null) {
      data['last_phone_call'] =
          this.lastPhoneCall!.map((v) => v.toJson()).toList();
    }
    if (this.lastSmsMsg != null) {
      data['last_sms_msg'] = this.lastSmsMsg!.map((v) => v.toJson()).toList();
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
    data['ssid'] = this.ssid;
    data['mac'] = this.mac;
    data['connection_type'] = this.connectionType;
    data['ip'] = this.ip;
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
    data['phone_number'] = this.phoneNumber;
    data['name'] = this.name;
    data['call_type'] = this.callType;
    data['sim_name'] = this.simName;
    data['timestamp'] = this.timestamp;
    data['duration'] = this.duration;
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
    data['address'] = this.address;
    data['body'] = this.body;
    data['date'] = this.date;
    return data;
  }
}
