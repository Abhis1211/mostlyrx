// To parse this JSON data, do
//
//     final driverLoginResponse = driverLoginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mostlyrx/core/models/user.dart';

DriverLoginResponse? driverLoginResponseFromJson(String str) =>
    DriverLoginResponse.fromJson(json.decode(str));

String driverLoginResponseToJson(DriverLoginResponse data) =>
    json.encode(data.toJson());

class DriverLoginResponse {
  DriverLoginResponse({
    this.status,
    this.code,
    this.message,
    this.response,
  });

  String? status;
  int? code;
  String? message;
  User? response;

  factory DriverLoginResponse.fromJson(Map<String, dynamic> json) =>
      DriverLoginResponse(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        response: User.fromJson(json['response']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'response': response?.toJson(),
      };
}
