import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/apimodels/route_detail_response.dart';
import 'package:mostlyrx/core/services/location_service.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';

class MapViewModel extends BaseModel {
  late Order order;
  late RouteDetail data;

  MapViewModel({
    required UserLocation locationService,
  });
}
