import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/apimodels/route_detail_response.dart';
import 'package:mostlyrx/core/apimodels/single_order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/services/api.dart';
import 'package:mostlyrx/core/services/order_service.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersViewModel extends BaseModel {
  final OrderService _orderService;
  List<Order>? orders;
  Order? order;
  OrderCollection? orderCollection;
  RouteDetail? data;

  OrdersViewModel({
    required OrderService orderService,
  }) : _orderService = orderService;

  Future<List<Order>?> getOrders(String id) async {
    setBusy(true);
    List<Order>? success = await _orderService.getActiveOrders(id);
    orders = success;
    setBusy(false);
    return success;
  }

  static Future<List<Order>> getLocalOrders() async {
    var pref = await SharedPreferences.getInstance();
    var localorders = pref.getStringList(kOrders) ?? [];
    List<Order> success = [];
    if (localorders.isNotEmpty) {
      for (var item in localorders) {
        var fetchedData = await Api().getOrderById(item);
        SingleOrderResponse? order = singleOrderResponseFromJson(fetchedData);
        if (order?.order != null) success.add(order!.order!);
      }
    }

    return success;
  }

  Future<List<Order>?> getPendingOrders(String id) async {
    setBusy(true);
    List<Order>? success = await _orderService.getPendingOrders(id);
    orders = success;
    setBusy(false);
    return success;
  }

  Future<bool?> acceptOrderBySignature(
      String id, String filePath, String orderId, String status) async {
    setBusy(true);
    var success = await _orderService.addSignature(id, filePath);
    if (success) {
      order = await _orderService.updateOrderRequestStatus(orderId, id, status);
    }
    setBusy(false);
    return success;
  }

  Future<RouteDetail?> getRoute(Order order) async {
    // this.order = order;
    setBusy(true);
    var success = await _orderService.getRoutes(order.id.toString());
    if (success != null) data = success;
    setBusy(false);
    return success;
  }

  Future<RouteDetail?> getSingleOrderRequestRoute(
      Order order, String requestId) async {
    // this.order = order;
    setBusy(true);
    var success =
        await _orderService.getSingleOrderRequestRoute(order, requestId);
    if (success != null) data = success;
    setBusy(false);
    return success;
  }

  Future<OrderCollection?> getOrderCollection(String id) async {
    setBusy(true);
    var success = await _orderService.getOrders(id);
    orderCollection = success;
    setBusy(false);
    return success;
  }

  Future<Order?> getOrderById(String id) async {
    setBusy(true);
    var success = await _orderService.getOrderById(id);
    setBusy(false);
    if (success != null) order = success;
    return success;
  }

  Future<bool> acceptOrder(int index, int id, {Order? order}) async {
    order = order ?? orders![index];
    setBusy(true);
    var resp = await _orderService.updateOrderStatus(order.id!, 'assigned', id);
    setBusy(false);
    return resp;
  }

  Future<bool> rejectOrder(int index, String driverIds, {Order? order}) async {
    order = order ?? orders![index];
    setBusy(true);
    var resp = await _orderService.rejectOrderRequest(order.id!, driverIds);
    setBusy(false);
    return resp;
  }

  getActiveOrder(context) {
    setBusy(true);
    Order order = Provider.of<Order>(context);
    setBusy(false);
    return order;
  }
}
