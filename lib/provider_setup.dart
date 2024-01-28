import 'package:location/location.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/models/notifications_model.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/core/services/location_service.dart';
import 'package:mostlyrx/core/services/order_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/models/user.dart';
import 'core/services/api.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticationService) =>
        AuthenticationService(api: api),
  ),
  ProxyProvider<Api, OrderService>(
    update: (context, api, orderService) => OrderService(api: api),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User?>(
    initialData: null,
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  ),
  StreamProvider<NotificationModel?>(
    initialData: null,
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).notification,
  ),
  StreamProvider<Order?>(
    initialData: null,
    create: (context) =>
        Provider.of<OrderService>(context, listen: false).order,
  ),
  StreamProvider<LocationData?>(
    initialData: null,
    create: (context) =>
        Provider.of<UserLocation>(context, listen: false).locationData,
  ),
  StreamProvider<OrderCollection?>(
    initialData: null,
    create: (context) =>
        Provider.of<OrderService>(context, listen: false).orderCollection,
  ),
  ChangeNotifierProvider(create: (context) => UserLocation())
];
