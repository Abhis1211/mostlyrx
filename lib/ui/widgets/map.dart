// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mostlyrx/core/constants/app_contstants.dart';
// import 'package:mostlyrx/core/constants/utils.dart';
// import 'package:mostlyrx/core/models/user.dart';
// import 'package:mostlyrx/core/services/order_service.dart';
// import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
// import 'package:mostlyrx/ui/constants/colors.dart';
// import 'package:provider/provider.dart';

// late OrdersViewModel _model;
// late User _user;

// class MapWidget extends StatefulWidget {
//   MapWidget(OrdersViewModel model, {Key? key}) : super(key: key) {
//     _model = model;
//   }

//   @override
//   _MapWidgetState createState() => _MapWidgetState();
// }

// class _MapWidgetState extends State<MapWidget> {
//   final Completer<GoogleMapController> _controller = Completer();

//   late Timer timer;

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(
//         const Duration(seconds: 5), (Timer t) => updateUserLocation());
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   List<LatLng> latLngs = [];
//   Marker? driverMarker;

//   @override
//   Widget build(BuildContext context) {
//     _user = Provider.of<User>(context);
//     if (_model.order!.orderStatus == 'complete') {
//       OrderService orderService = Provider.of(context, listen: false);
//       orderService.getOrders(_user.id.toString());
//       return const Center(
//         child: Text('This order is complete'),
//       );
//     }

//     // ignore: avoid_print
//     print('-----------21313' + _model.data!.data.status);
//     String polyline = _model.data!.data.routes![0].overviewPolyline.points;
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> result = polylinePoints.decodePolyline(polyline);
//     if (latLngs.isEmpty) {
//       for (var element in result) {
//         latLngs.add(LatLng(element.latitude, element.longitude));
//       }
//     }
//     polylines.add(Polyline(
//         polylineId: const PolylineId('1'),
//         points: latLngs,
//         color: AppColors.primaryColor,
//         width: 6));
//     addMarker(_model.order!.pharmacy!.id.toString(), 'Pick Up', latLngs[0]);
//     int i = 1;
//     for (var element in _model.order!.orderRequests!) {
//       try {
//         addMarker(
//             element.customerName! + element.id.toString(),
//             element.customerName!,
//             LatLng(double.parse(element.customerLatitude!),
//                 double.parse(element.customerLongitude!)),
//             label: i++);
//       } on Exception catch (_) {
//         Utils.showToast('Turn your location On and try again!', Colors.red);
//       }
//     }

//     return Stack(
//       children: [
//         GoogleMap(
//           mapType: MapType.terrain,
//           markers: markers,
//           polylines: polylines,
//           onMapCreated: (GoogleMapController controller) {
//             _controller.complete(controller);
//             _goToTheLake();
//           },
//           initialCameraPosition: CameraPosition(target: latLngs[0]),
//         ),
// //
//       ],
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(
//         CameraUpdate.newLatLngBounds(boundsFromLatLngList(latLngs), 30));
//   }

//   Future<Marker> addMarker(String title, String snippet, LatLng pos,
//       {String? assetIcon, int? label}) async {
//     Marker resultMarker;
//     if (assetIcon != null) {
//       final d = await BitmapDescriptor.fromAssetImage(
//           const ImageConfiguration(size: Size(12, 12)),
//           'assets/images/$assetIcon');
//       resultMarker = Marker(
//           markerId: MarkerId(title),
//           icon: d,
//           infoWindow: InfoWindow(
//             title: title,
//             snippet: snippet,
//           ),
//           position: pos);
//     } else {
//       BitmapDescriptor bitmapDescriptor = await Utils.createCustomMarkerBitmap(
//           context, label == null ? 'P' : label.toString(),
//           bgColor: label == null ? AppColors.primaryColor : Colors.black);

//       resultMarker = Marker(
//           markerId: MarkerId(title),
//           infoWindow: InfoWindow(
//             title: title,
//             snippet: snippet,
//           ),
//           icon: bitmapDescriptor,
//           position: pos);
//     }
//     markers.add(resultMarker);
//     return resultMarker;
//   }

//   LatLngBounds boundsFromLatLngList(List<LatLng> list) {
//     assert(list.isNotEmpty);
//     double? x0, x1, y0, y1;
//     for (LatLng latLng in list) {
//       if (x0 == null) {
//         x0 = x1 = latLng.latitude;
//         y0 = y1 = latLng.longitude;
//       } else {
//         if (latLng.latitude > x1!) x1 = latLng.latitude;
//         if (latLng.latitude < x0) x0 = latLng.latitude;
//         if (latLng.longitude > y1!) y1 = latLng.longitude;
//         if (latLng.longitude < y0!) y0 = latLng.longitude;
//       }
//     }
//     return LatLngBounds(
//         northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
//   }

//   updateUserLocation() async {
//     // ignore: avoid_print
//     print('yes');
//     if (Constants.loggedInUser!.latitude != null) {
//       driverMarker = await addMarker(
//           'Me',
//           'Driver',
//           LatLng(Constants.loggedInUser!.latitude!,
//               Constants.loggedInUser!.longitude!),
//           assetIcon: 'driver_icon.png');
//       setState(() {});
//     }
//   }
// }
