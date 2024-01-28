// To parse this JSON data, do
//
//     final earningsResponse = earningsResponseFromJson(jsonString);

import 'dart:convert';

EarningsResponse? earningsResponseFromJson(String str) =>
    EarningsResponse.fromJson(json.decode(str));

String earningsResponseToJson(EarningsResponse data) =>
    json.encode(data.toJson());

class EarningsResponse {
  EarningsResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.response,
  });

  String status;
  int code;
  String message;
  Earnings response;

  factory EarningsResponse.fromJson(Map<String, dynamic> json) =>
      EarningsResponse(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        response: Earnings.fromJson(json['response']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'response': response.toJson(),
      };
}

class Earnings {
  Earnings(
      {required this.thisMonthOrders,
      required this.currentMonthEarnedAmount,
      required this.totalEarning,
        required this.thisWeekEarning,
        required this.totalOrders,
        required this.duration_start,
        required this.duration_end,
        required this.duration_current,
      required this.payementRecord});

  List<ThisMonthOrder> thisMonthOrders;
  List<LastWeekEarning> thisWeekEarning;

  String currentMonthEarnedAmount;

  String totalEarning;
  String totalOrders;
  String duration_start;
  String duration_end;
  String duration_current;
  List<PayementRecord> payementRecord;

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
      thisWeekEarning: List<LastWeekEarning>.from(
          json['this_week_earning'].map((x) => LastWeekEarning.fromJson(x))),
      thisMonthOrders: List<ThisMonthOrder>.from(
          json['current_period_orders'].map((x) => ThisMonthOrder.fromJson(x))),
      currentMonthEarnedAmount: json['current_period_earned_amount'],
      totalEarning: json['total_earning'],
      totalOrders: json['total_no_orders'].toString(),
      duration_start: json['duration_start'].toString(),
      duration_end: json['duration_end'].toString(),
      duration_current: json['current_time'].toString(),
      payementRecord: (json['payment_records'] as List)
          .map((item) => PayementRecord.fromJson(item))
          .toList());

  Map<String, dynamic> toJson() => {
        'this_month_orders':
            List<dynamic>.from(thisMonthOrders.map((x) => x.toJson())),
        'current_month_earned_amount': currentMonthEarnedAmount,
        'total_earning': totalEarning,
      };
}

class PayementRecord {
  late int id;
  late String invoiceableId;
  late String invoiceableType;
  late String fromDate;
  late String toDate;
  late String dueDate;
  late String status;
  late String invoiceTotal;
  late String createdAt;
  late String updatedAt;
  PayementRecord(
      {required this.id,
      required this.invoiceableId,
      required this.invoiceableType,
      required this.fromDate,
      required this.toDate,
      required this.dueDate,
      required this.status,
      required this.invoiceTotal,
      required this.createdAt,
      required this.updatedAt});
  PayementRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceableId = json['invoiceable_id'].toString();
    invoiceableType = json['invoiceable_type'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    dueDate = json['due_date'];
    status = json['status'];
    invoiceTotal = json['invoice_total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class ThisMonthOrder {
  ThisMonthOrder({
    required this.id,
    required this.customerName,
    required this.lastName,
    required this.address,
    required this.customerLatitude,
    required this.customerLongitude,
    required this.contact,
    required this.distance,
    required this.orderRequestStatus,
    required this.deliveryStatus,
    required this.scheduleTime,
    required this.deliverySetting,
    required this.notes,
    required this.deliveryPrice,
    required this.orderId,
    required this.orderPrice,
    required this.fkAssignedDriverId,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String customerName;
  dynamic lastName;
  String address;
  String customerLatitude;
  String customerLongitude;
  String contact;
  dynamic distance;
  String orderRequestStatus;
  String deliveryStatus;
  String scheduleTime;
  dynamic deliverySetting;
  String notes;
  num deliveryPrice;
  String orderId;
  String orderPrice;
  String fkAssignedDriverId;
  DateTime createdAt;
  DateTime updatedAt;

  factory ThisMonthOrder.fromJson(Map<String, dynamic> json) => ThisMonthOrder(
        id: json['id'].toString(),
        customerName: json['customer_name'],
        lastName: json['last_name'],
        address: json['address'],
        customerLatitude: json['customer_latitude'],
        customerLongitude: json['customer_longitude'],
        contact: json['contact'],
        distance: json['distance'],
        orderRequestStatus: json['order_request_status'],
        deliveryStatus: json['delivery_status'],
        scheduleTime: json['schedule_time'],
        deliverySetting: json['delivery_setting'],
        notes: json['notes'],
        deliveryPrice: json['delivery_price_driver'],
        orderId: json['order_id']?.toString() ?? '',
        orderPrice: json['order_price'],
        fkAssignedDriverId: json['fk_assigned_driver_id']?.toString() ?? '',
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_name': customerName,
        'last_name': lastName,
        'address': address,
        'customer_latitude': customerLatitude,
        'customer_longitude': customerLongitude,
        'contact': contact,
        'distance': distance,
        'order_request_status': orderRequestStatus,
        'delivery_status': deliveryStatus,
        'schedule_time': scheduleTime,
        'delivery_setting': deliverySetting,
        'notes': notes,
        'delivery_price': deliveryPrice,
        'order_id': orderId,
        'order_price': orderPrice,
        'fk_assigned_driver_id': fkAssignedDriverId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

class LastWeekEarning {
  LastWeekEarning({
    required this.total_earning,
    required this.day,
    required this.date,
  });

  String total_earning;
  String day;
  DateTime date;

  factory LastWeekEarning.fromJson(Map<String, dynamic> json) => LastWeekEarning(
    total_earning: json['total_earning'].toString(),
    day: json['day'],
    date: DateTime.parse(json['date']),
  );

}
