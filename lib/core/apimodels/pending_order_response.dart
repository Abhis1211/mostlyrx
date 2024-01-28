// To parse this JSON data, do
//
//     final pendingOrderResponse = pendingOrderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:mostlyrx/core/apimodels/order_response.dart';

PendingOrderResponse? pendingOrderResponseFromJson(String str) =>
    PendingOrderResponse.fromJson(json.decode(str));

String pendingOrderResponseToJson(PendingOrderResponse data) =>
    json.encode(data.toJson());

class PendingOrderResponse {
  PendingOrderResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.response,
  });

  String status;
  int code;
  String message;
  List<Order>? response;

  factory PendingOrderResponse.fromJson(Map<String, dynamic> json) =>
      PendingOrderResponse(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        response: json['response'] != null
            ? List<Order>.from(json['response'].map((x) => Order.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'response': List<dynamic>.from(response!.map((x) => x.toJson())),
      };
}
