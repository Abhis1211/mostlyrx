import 'package:flutter/src/widgets/framework.dart';
import 'package:mostlyrx/core/apimodels/earnings_response.dart';
import 'package:mostlyrx/core/apimodels/notification_model.dart';
import 'package:mostlyrx/core/services/order_service.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';
import 'package:mostlyrx/core/viewmodels/views/notification_count_model.dart';
import 'package:provider/provider.dart';

class NotificationViewModel extends BaseModel {
  final OrderService _orderService;
   List<NotificationData> notifcations=[];
  NotificationViewModel({
    required OrderService orderService,
  }) : _orderService = orderService;

  Future<List<NotificationData>?> getNotifications(String id) async {
    setBusy(true);
    var success = await _orderService.getNotifications(id);
    if (success != null) notifcations = success;
    setBusy(false);
    return success;
  }
}
