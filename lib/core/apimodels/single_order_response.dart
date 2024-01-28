import 'dart:convert';

import 'package:mostlyrx/core/apimodels/order_response.dart';

SingleOrderResponse? singleOrderResponseFromJson(String str) =>
    SingleOrderResponse.fromJson(json.decode(str));

String singleOrderResponseToJson(SingleOrderResponse data) =>
    json.encode(data.toJson());

class SingleOrderResponse {
  SingleOrderResponse({
    this.status,
    this.code,
    this.message,
    this.order,
  });

  String? status;
  int? code;
  String? message;
  Order? order;

  factory SingleOrderResponse.fromJson(Map<String, dynamic> json) =>
      SingleOrderResponse(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        order:
            json['response'] != null ? Order.fromJson(json['response']) : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'response': order!.toJson(),
      };
}
