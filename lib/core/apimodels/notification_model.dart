// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  String? status;
  int? code;
  String? message;
  List<NotificationData>? response;

  NotificationModel({
    this.status,
    this.code,
    this.message,
    this.response,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    response: json["response"] == null ? [] : List<NotificationData>.from(json["response"]!.map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x.toJson())),
  };
}

class NotificationData {
  int? id;
  String? title;
  String? content;
  DateTime? updatedAt;
  DateTime? createdAt;

  NotificationData({
    this.id,
    this.title,
    this.content,
    this.updatedAt,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
  };
}
