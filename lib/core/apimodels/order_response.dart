// To parse this JSON data, do
//
//     final OrderBookingResponse = OrderBookingResponseFromJson(jsonString);

import 'dart:convert';

import 'package:maps_toolkit/maps_toolkit.dart';

OrderBookingResponse? orderBookingResponseFromJson(String str) =>
    OrderBookingResponse.fromJson(json.decode(str));

String orderBookingResponseToJson(OrderBookingResponse data) =>
    json.encode(data.toJson());

class OrderBookingResponse {
  OrderBookingResponse({
    this.status,
    this.code,
    this.message,
    this.orderCollection,
  });

  String? status;
  int? code;
  String? message;
  OrderCollection? orderCollection;

  factory OrderBookingResponse.fromJson(Map<String, dynamic> json) =>
      OrderBookingResponse(
        status: json['status'],
        code: json['code'],
        message: json['message'],
        orderCollection: OrderCollection.fromJson(json['response']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'code': code,
        'message': message,
        'response': orderCollection!.toJson(),
      };
}

class OrderCollection {
  OrderCollection({
    this.active,
    this.completed,
    this.cancelled,
  });

  List<Order>? active;
  List<Order>? completed;
  List<Order>? cancelled;

  factory OrderCollection.fromJson(Map<String, dynamic> json) =>
      OrderCollection(
        active: List<Order>.from(json['active'].map((x) => Order.fromJson(x))),
        completed: json['completed'] != null
            ? List<Order>.from(json['completed'].map((x) => Order.fromJson(x)))
            : null,
        cancelled: json['cancelled'] != null
            ? List<Order>.from(json['cancelled'].map((x) => Order.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'active': List<Order>.from(active!.map((x) => x.toJson())),
        'completed': List<Order>.from(completed!.map((x) => x.toJson())),
        'cancelled': List<Order>.from(cancelled!.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.id,
    this.orderStatus,
    this.spacimenSignature,
    this.fkPharmacyId,
    this.fkAssignedDriverId,
    this.createdAt,
    this.updatedAt,
    this.totalPrice,
    this.totalStops,
    this.pharmacy,
    this.orderRequests,
  });

  late int? id;
  late String? orderStatus;
  late String? spacimenSignature;
  late String? fkPharmacyId;
  late String? totalPrice;
  late String? totalStops;
  late String? fkAssignedDriverId;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late Pharmacy? pharmacy;
  late List<OrderRequest>? orderRequests;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
    totalPrice: json['total_price'].toString(),
    totalStops: json['total_stops'].toString(),
        orderStatus: json['order_status'],
        spacimenSignature: json['spacimen_signature'],
        fkPharmacyId: json['fk_pharmacy_id'].toString(),
        fkAssignedDriverId: json['fk_assigned_driver_id'].toString(),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at']),
        pharmacy: json['pharmacy'] != null
            ? Pharmacy.fromJson(json['pharmacy'])
            : null,
        orderRequests: List<OrderRequest>.from(
            json['order_requests'].map((x) => OrderRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_status': orderStatus,
        'spacimen_signature': spacimenSignature,
        'fk_pharmacy_id': fkPharmacyId,
        'fk_assigned_driver_id': fkAssignedDriverId,
        'created_at': createdAt!.toIso8601String(),
        'updated_at': updatedAt!.toIso8601String(),
        'pharmacy': pharmacy!.toJson(),
        'order_requests':
            List<dynamic>.from(orderRequests!.map((x) => x.toJson())),
      };
}

class OrderRequest {
  OrderRequest(
      {this.id,
      // ignore: non_constant_identifier_names
      this.prev_order_request_id,
      this.customerName,
      this.lastName,
      this.address,
      // ignore: non_constant_identifier_names
      this.from_address,
      this.customerLatitude,
      this.customerLongitude,
      this.contact,
      this.distance,
      this.orderRequestStatus,
      this.deliveryStatus,
      this.scheduleTime,
      this.deliverySetting,
      this.notes,
      this.deliveryPrice,
      this.orderId,
      this.orderPrice,
      this.fkAssignedDriverId,
      this.createdAt,
      this.updatedAt,
      // ignore: non_constant_identifier_names
      this.parent_order_request,
      this.requestNum});

  int? id;
  // ignore: non_constant_identifier_names
  String? prev_order_request_id;

  // ignore: non_constant_identifier_names
  OrderRequest? parent_order_request;
  String? customerName;
  String? lastName;
  String? address;
  // ignore: non_constant_identifier_names
  String? from_address;
  String? customerLatitude;
  String? customerLongitude;
  String? contact;
  String? requestNum;
  String? distance;
  String? orderRequestStatus;
  String? deliveryStatus;
  String? scheduleTime;
  String? deliverySetting;
  String? notes;
  num? deliveryPrice;
  String? orderId;
  String? orderPrice;
  int? fkAssignedDriverId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        id: json['id'],
    requestNum: json['request_num'].toString(),
        prev_order_request_id: json['prev_order_request_id'].toString(),
        customerName: json['customer_name'],
        lastName: json['last_name'],
        address: json['address'],
        from_address: json['from_address'],
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
        orderId: json['order_id'].toString(),
        orderPrice: json['order_price'],
        //parent_order_request:json["parent_order_request"],
        parent_order_request: json['parent_order_request'] != null
            ? OrderRequest.fromJson(json['parent_order_request'])
            : null,
        fkAssignedDriverId: json['fk_assigned_driver_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'prev_order_request_id': prev_order_request_id,
        'customer_name': customerName,
        'last_name': lastName,
        'address': address,
        'from_address': from_address,
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
        'parent_order_request': parent_order_request?.toJson(),
        'fk_assigned_driver_id': fkAssignedDriverId,
        'created_at': createdAt!.toIso8601String(),
        'updated_at': updatedAt!.toIso8601String(),
      };

  num distanceBetween(double latitude, double longitude) {
    if (customerLatitude != null &&
        customerLongitude != null &&
        customerLatitude!.isNotEmpty &&
        customerLongitude!.isNotEmpty &&
        latitude != 0 &&
        longitude != 0) {
      return SphericalUtil.computeDistanceBetween(
          LatLng(latitude, longitude),
          LatLng(double.tryParse(customerLatitude!) ?? 0,
              double.tryParse(customerLongitude!) ?? 0));
    }
    return -1;
  }
}

class Pharmacy {
  Pharmacy({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.photo,
  });

  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? photo;

  factory Pharmacy.fromJson(Map<String, dynamic> json) => Pharmacy(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        phone: json['phone'],
        photo: json['photo'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'photo': photo,
      };
}
