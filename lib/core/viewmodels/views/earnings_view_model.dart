import 'package:mostlyrx/core/apimodels/earnings_response.dart';
import 'package:mostlyrx/core/services/order_service.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';

class EarningsViewModel extends BaseModel {
  final OrderService _orderService;
  late Earnings earnings;
  EarningsViewModel({
    required OrderService orderService,
  }) : _orderService = orderService;

  Future<Earnings?> getEarnings(String id) async {
    setBusy(true);
    var success = await _orderService.getEarnings(id);
    if (success != null) earnings = success;
    setBusy(false);
    return success;
  }
}
