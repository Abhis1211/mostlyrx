import 'package:flutter/material.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/view/base_widget.dart';
import 'package:provider/provider.dart';

class MapViewRouteArgs {
  final Order order;
  final String requestId;
  MapViewRouteArgs(this.order, this.requestId);
}

class MapTTnView extends StatefulWidget {
  final MapViewRouteArgs _args;
  const MapTTnView(this._args, {Key? key}) : super(key: key);

  @override
  State<MapTTnView> createState() => _MapTTnViewState();
}

class _MapTTnViewState extends State<MapTTnView> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<OrdersViewModel>(
      model: OrdersViewModel(orderService: Provider.of(context)),
      onModelReady: (model) => model.getSingleOrderRequestRoute(
          widget._args.order, widget._args.requestId),
      builder: (context, model, child) {
        model.order = widget._args.order;
        return Scaffold(
          appBar: AppBar(
            title: const Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text('Map View'),
            ),
          ),
          body: model.busy
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : model.data != null && model.data!.data.status != 'ZERO_RESULTS'
                  ? const Text('Problem')
                  : const Center(
                      child: Text('Cannot fetch route!'),
                    ),
        );
      },
    );
//    return Scaffold(
//      appBar: AppBar(title: Align(alignment: AlignmentDirectional.centerStart, child: Text('Map View'),),),
//      body:
//    );
  }
}
