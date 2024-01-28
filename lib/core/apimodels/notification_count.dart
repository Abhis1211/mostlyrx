// To parse this JSON data, do
//
//     final notificationCountModel = notificationCountModelFromJson(jsonString);

import 'dart:convert';

NotificationCountModel notificationCountModelFromJson(String str) => NotificationCountModel.fromJson(json.decode(str));

String notificationCountModelToJson(NotificationCountModel data) => json.encode(data.toJson());

class NotificationCountModel {
  String? status;
  int? code;
  String? message;
  int? response;

  NotificationCountModel({
    this.status,
    this.code,
    this.message,
    this.response,
  });

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) => NotificationCountModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "response": response,
  };
}
