import 'package:flutter/foundation.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';

class NotificationModel extends ChangeNotifier {
  String? data;

  NotificationModel(this.data);

  Order? order;
  List<int> driverIds = [];

  getOrder(AuthenticationService auth) async {
    if (order == null) {
      return order = await auth.getOrderById(data ?? '');
    } else {
      return order;
    }
  }

  void update() {
    notifyListeners();
  }
}
