import 'dart:async';

import 'package:logger/logger.dart';
import 'package:mostlyrx/core/apimodels/earnings_response.dart';
import 'package:mostlyrx/core/apimodels/notification_count.dart';
import 'package:mostlyrx/core/apimodels/notification_model.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/apimodels/pending_order_response.dart';
import 'package:mostlyrx/core/apimodels/route_detail_response.dart';
import 'package:mostlyrx/core/apimodels/single_order_response.dart';
import 'package:mostlyrx/core/services/api.dart';

class OrderService {
  final Api _api;

  OrderService({required Api api}) : _api = api;

  final StreamController<Order> _orderController = StreamController<Order>();
  final StreamController<List<Order>> _pendingIOrderController =
      StreamController<List<Order>>();
  final StreamController<OrderCollection> _orderCollectionController =
      StreamController<OrderCollection>();
  final StreamController<Earnings> _earningsController =
      StreamController<Earnings>();
  final StreamController<int> _notiCountController =
  StreamController<int>();
  final StreamController<List<NotificationData>> _notificationController =
  StreamController<List<NotificationData>>();

  Stream<Order> get order => _orderController.stream;

  Stream<List<Order>> get pendingOrder => _pendingIOrderController.stream;

  Stream<OrderCollection> get orderCollection =>
      _orderCollectionController.stream;

  Stream<Earnings> get earnings => _earningsController.stream;

  Stream<int> get notiCounts => _notiCountController.stream;

  Stream<List<NotificationData>> get notificatoins => _notificationController.stream;

  final StreamController<RouteDetail> _routeDetailController =
      StreamController<RouteDetail>();

  Stream<RouteDetail> get routeDetail => _routeDetailController.stream;

  Future<Order?> getOrderById(String id) async {
    var fetchedData = await _api.getOrderById(id);
    if (fetchedData != null) {
      SingleOrderResponse? order = singleOrderResponseFromJson(fetchedData);
      var hasData = order != null;
      if (hasData) {
        _orderController.add(order.order!);
        return order.order!;
      }
      return null;
    }
    return null;
  }

  Future<RouteDetail?> getRoutes(String id) async {
    var fetchedData = await _api.getRoute(id);
    if (fetchedData != null) {
      RouteDetail? routeDetail = routeDetailFromJson(fetchedData);
      var hasData = routeDetail != null;
      if (hasData) {
        _routeDetailController.add(routeDetail);
        return routeDetail;
      }
      return null;
    }
    return null;
  }

  Future<RouteDetail?> getSingleOrderRequestRoute(
      Order order, String requestId) async {
    var fetchedData = await _api.getSingleOrderRequestRoute(
        {'order_id': order.id.toString(), 'order_request_id': requestId});
    if (fetchedData != null) {
      RouteDetail? routeDetail = routeDetailFromJson(fetchedData);
      var hasData = routeDetail != null;
      if (hasData) {
        _routeDetailController.add(routeDetail);
        return routeDetail;
      }
      return null;
    }
    return null;
  }

  Future<List<Order>?> getPendingOrders(String id) async {
    var fetchedData = await _api.getPendingOrders(id);
    if (fetchedData != null) {
      PendingOrderResponse? order = pendingOrderResponseFromJson(fetchedData);
      var hasData = order != null;
      if (hasData) {
        _pendingIOrderController.add(order.response!);
        return order.response;
      }
      return null;
    }
    return null;
  }

  Future<List<Order>?> getActiveOrders(String id) async {
    var fetchedData = await _api.getOrders(id);
    if (fetchedData != null) {
      OrderBookingResponse? order = orderBookingResponseFromJson(fetchedData);
      var hasData = order != null;
      if (hasData) {
        _orderCollectionController.add(order.orderCollection!);
        if (order.orderCollection!.active!.isNotEmpty) {
          _orderController.add(order.orderCollection!.active![0]);
        }
      }
      return order!.orderCollection!.active;
    }
    return null;
  }

  Future<Earnings?> getEarnings(String id) async {
    var fetchedData = await _api.getEarning(id);
    if (fetchedData != null) {
      EarningsResponse? earnings = earningsResponseFromJson(fetchedData);
      var hasData = earnings != null;
      if (hasData) {
        _earningsController.add(earnings.response);
      }
      return earnings!.response;
    }
    return null;
  }

  Future<int?> getNotificationCount(String id) async {
    var fetchedData = await _api.getNotificationCount(id);
    if (fetchedData != null) {
      NotificationCountModel? notificationCountModel = notificationCountModelFromJson(fetchedData);
      var hasData = notificationCountModel != null;
      if (hasData) {
        _notiCountController.add(notificationCountModel.response??0);
      }
      return notificationCountModel.response;
    }
    return null;
  }

  Future<List<NotificationData>?> getNotifications(String id) async {
    var fetchedData = await _api.getNotifications(id);
    if (fetchedData != null) {
      NotificationModel? notificationModel = notificationModelFromJson(fetchedData);
      var hasData = notificationModel != null;
      if (hasData) {
        _notificationController.add(notificationModel.response!);
      }
      return notificationModel.response;
    }
    return null;
  }

  Future<OrderCollection?> getOrders(String id) async {
    var fetchedData = await _api.getOrders(id);
    if (fetchedData != null) {
      OrderBookingResponse? order = orderBookingResponseFromJson(fetchedData);
      var hasData = order != null;
      if (hasData) {
        _orderCollectionController.add(order.orderCollection!);
        return order.orderCollection;
      }
    }
    return null;
  }

  Future<bool> updateOrderStatus(int id, String status, int userId) async {
    var resp = await _api.updateOrderStatus({
      'order_id': id.toString(),
      'order_status': status,
      'fk_assigned_driver_id': userId.toString()
    });
    return resp != null;
  }

  Future<bool> rejectOrderRequest(int id, String driverIds) async {
    var resp = await _api.rejectOrderRequest({
      'order_id': id.toString(),
      'driver_id': driverIds.toString(),
    });
    return resp != null;
  }

  Future<bool> addSignature(String id, String filePath) async {
    var resp = await _api.addSignature(id.toString(), filePath);
    return resp != null;
  }

  Future<Order?> updateOrderRequestStatus(
      String orderId, String orderRequestId, String status) async {
    var resp = await _api.updateOrderRequestStatus(
        {'order_id': orderId, 'status': status, 'id': orderRequestId});
    Logger().v(resp);
    if (resp != null) {
      SingleOrderResponse? order = singleOrderResponseFromJson(resp);
      return order!.order;
    }
    return resp;
  }
}
