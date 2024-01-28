import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/services/order_service.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/widgets/map_details_modal.dart';
import 'package:mostlyrx/ui/widgets/order_details.dart';
import 'package:provider/provider.dart';

class MapBoxView extends StatefulWidget {
  final OrdersViewModel model;
  const MapBoxView(this.model, {Key? key}) : super(key: key);

  @override
  State<MapBoxView> createState() => _MapBoxViewState();
}

class _MapBoxViewState extends State<MapBoxView>
    with AutomaticKeepAliveClientMixin {
  OrdersViewModel get _model => widget.model;
  User? _user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _user = Provider.of<User?>(context);
    if (_model.order!.orderStatus == 'complete') {
      OrderService orderService = Provider.of(context, listen: false);
      orderService.getOrders(_user!.id.toString());
      return const Center(
        child: Text('This order is complete'),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/vectors/Vector 4.png',
              width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
          Positioned(
              bottom: 0,
              child: Image.asset('assets/vectors/Vector 1.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth)),
          Positioned(
              bottom: MediaQuery.of(context).size.height * .65,
              child: Image.asset('assets/vectors/vector 3.png')),
          Positioned(
              bottom: 0, child: Image.asset('assets/vectors/Vector 2.png')),
          Column(
            children: [
              AppBar(
                centerTitle: false,
                toolbarHeight: 70,
                foregroundColor: Colors.white,
                shadowColor: Colors.black.withOpacity(0.5),
                toolbarOpacity: 0.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                leadingWidth: 100,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Image.asset('assets/images/app_logo.png',
                      width: 90, height: 80),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  minVerticalPadding: 0,
                  leading: IconButton(
                      icon: Image.asset('assets/icons/Arrow_back.png',
                          width: 60, height: 60),
                      onPressed: () {

                        Navigator.pop(context);
                      }),
                  title: const Text(
                    'Order Dashboard',
                    style: TextStyle(color: Color(0xFF828282), fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Expanded(
                child: OrderMapModalWidget(_model.order!,
                    onButtonTap: (OrderRequest orderRequest) async {
                      Constants.selectedOrderRequest = orderRequest;
                      var file = await Navigator.of(context)
                          .pushNamed('/signature_pad', arguments: _model);

                      if (file != null) {
                        var result = await _model.acceptOrderBySignature(
                            Constants.selectedOrderRequest!.id.toString(),
                            (file as File).path,
                            _model.order!.id.toString(),
                            Constants.selectedOrderRequest!.deliveryStatus ==
                                    'pending'
                                ? 'onway'
                                : 'complete');
                        if (result != null) {
                          OrderDetailsWidget.clicked = true;
                          Utils.showToast(
                              'Order Request Complete', Colors.green);
                          Constants.selectedOrderRequest!.orderRequestStatus =
                              'complete';
                          if (widget.model.order!.orderRequests!.length == 1) {
                            Navigator.of(Constants
                                .appNavigationKey.currentState!.context).pushNamed('/order_status_screen',
                                arguments: ["Order Completed!","order_completed.png",2]);

/*
                            Navigator.of(Constants
                                    .appNavigationKey.currentState!.context)
                                .pushNamedAndRemoveUntil(
                                    '/home', (Route<dynamic> route) => false,
                                    arguments: 1);
*/
                          }
                        } else {
                          Utils.showToast(
                              'Order Request not Complete', Colors.red);
                          if (mounted) {
                            Utils.showAlert(context, 'Unsuccessful',
                                'Order Request not Complete');
                          }
                        }
                      }
                    },
                    onNavigation: (OrderRequest orderRequest) async {},
                    onInAppMap: (OrderRequest orderRequest) async {
                      LatLng? endPoint;
                      if (orderRequest.customerLatitude != null &&
                          orderRequest.customerLongitude != null) {
                        print(orderRequest.customerLatitude);
                        endPoint = LatLng(
                            double.parse(orderRequest.customerLatitude!.isEmpty?
                            "0.0":orderRequest.customerLatitude.toString()),
                            double.parse(orderRequest.customerLongitude!.isEmpty?
                            "0.0":orderRequest.customerLongitude.toString()));
                      }
                      if (endPoint == null) {
                        Fluttertoast.showToast(msg: 'Destination is unknown');
                        return;
                      }

                      try {
                        //OLD CODE
                        if (orderRequest.prev_order_request_id == null) {
                          Utils.openMap(
                              Constants.loggedInUser!.latitude!,
                              Constants.loggedInUser!.longitude!,
                              double.parse(_model.order!.pharmacy!.latitude!),
                              double.parse(_model.order!.pharmacy!.longitude!),
                              double.parse(orderRequest.customerLatitude!),
                              double.parse(orderRequest.customerLongitude!));
                        } else {
                          await Utils.navigate(endPoint: endPoint);
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Can't get Directions!!!");
                      }
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
