import 'package:flutter/material.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';

import 'package:mostlyrx/ui/view/base_widget.dart';

import 'package:mostlyrx/ui/widgets/map_ttn.dart';
import 'package:provider/provider.dart';

Order? _order;

class MapView extends StatefulWidget {
  MapView(Order order, {Key? key}) : super(key: key) {
    _order = order;
  }

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<OrdersViewModel>(
      model: OrdersViewModel(orderService: Provider.of(context)),
      builder: (context, model, child) {
        model.order = _order;
        return Scaffold(
            body: model.busy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : MapBoxView(model));
      },
    );
  }
}
