import 'package:mostlyrx/core/apimodels/earnings_response.dart';
import 'package:mostlyrx/core/apimodels/notification_count.dart';
import 'package:mostlyrx/core/services/order_service.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';

class NotificationViewModel extends BaseModel {
  final OrderService _orderService;
  int notiCount=0;
  NotificationViewModel({
    required OrderService orderService,
  }) : _orderService = orderService;

  Future<int?> getNotification(String id) async {
    setBusy(true);
    var success = await _orderService.getNotificationCount(id);
    if (success != null) notiCount = success;
    setBusy(false);
    return success;
  }
}
