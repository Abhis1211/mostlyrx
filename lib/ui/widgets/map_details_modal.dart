import 'package:flutter/material.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';

class OrderMapModalWidget extends StatefulWidget {
  final Order order;
  final Function onButtonTap, onNavigation, onInAppMap;

  const OrderMapModalWidget(this.order,
      {required this.onButtonTap,
      required this.onNavigation,
      required this.onInAppMap,
      Key? key})
      : super(key: key);

  @override
  State<OrderMapModalWidget> createState() => _OrderMapModalWidgetState();
}

class _OrderMapModalWidgetState extends State<OrderMapModalWidget> {
  @override
  void initState() {
    super.initState();
    if (Constants.selectedOrderRequest != null &&
        Constants.selectedOrderRequest!.orderRequestStatus! == 'complete') {
      int index =
          widget.order.orderRequests!.indexOf(Constants.selectedOrderRequest!);

      widget.order.orderRequests![index] = Constants.selectedOrderRequest!;
      Constants.selectedOrderRequest = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: widget.order.orderRequests!.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return OrderDashboardItem(
          widget.order.orderRequests![index],
          order: widget.order,
          isFirst: index == 0,
          onButtonTap: widget.onButtonTap,
          onInAppMap: widget.onInAppMap,
        );
      },
    );
  }
}

class OrderDashboardItem extends StatefulWidget {
  final Order order;
  final OrderRequest orderRequest;
  final bool isFirst;
  final Function onInAppMap;
  final Function onButtonTap;
  const OrderDashboardItem(this.orderRequest,
      {required this.onInAppMap,
      required this.onButtonTap,
      required this.order,
      this.isFirst = false,
      Key? key})
      : super(key: key);

  @override
  State<OrderDashboardItem> createState() => _OrderDashboardItemState();
}

class _OrderDashboardItemState extends State<OrderDashboardItem> {
  num distanceBettwen = -1;
  String get distance {
    String inKm = '';
    if (distanceBettwen > 100000) {
      inKm = '+1000 KM';
    } else if (distanceBettwen > 1000) {
      inKm = '${(distanceBettwen / 1000).toStringAsPrecision(2)} KM';
    } else {
      inKm = '${distanceBettwen.toInt()} M';
    }

    return inKm;
  }

  @override
  void initState() {
    setState(() {
      distanceBettwen = widget.orderRequest.distanceBetween(
          double.tryParse(widget.order.pharmacy!.latitude!) ?? 0,
          double.tryParse(widget.order.pharmacy!.longitude!) ?? 0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.orderRequest.orderRequestStatus == 'complete';
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
      child: Card(
          elevation: 0.9,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Color.fromRGBO(101, 197, 141, 0.5), width: 5),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(widget.orderRequest.customerName ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF1EA256))),
                    ),
                    if (distanceBettwen != -1)
                      Row(
                        children: [
                          Text.rich(TextSpan(
                            children: [
                              TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  text: distance.split(' ').last)
                            ],
                            text: '${distance.split(' ').first} ',
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                          const SizedBox(width: 5),
                          if (distanceBettwen != -1)
                            Image.asset('assets/icons/distance.png',
                                width: 30, height: 30),
                        ],
                      ),
                  ],
                ),
                if (done)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/order.png',
                            width: 60, height: 60),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color(0xFF65C58D)),
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {},
                            child: const Text(' Delivered',
                                style: TextStyle(
                                    color: Color(0xFF43A047), fontSize: 13))),
                      ],
                    ),
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Delivery Address : ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF65C58D),
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(widget.orderRequest.address ?? ''),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                              onPressed: () {
                                if (widget.orderRequest.orderRequestStatus !=
                                    'complete') {
                                  widget.onInAppMap(widget.orderRequest);
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset('assets/icons/distance_v2.png',
                                      width: 16, height: 16),
                                  const SizedBox(width: 5),
                                  const Text('Get Directions',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                ],
                              )),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Color(0xFF65C58D)),
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                widget.onButtonTap(widget.orderRequest);
                              },
                              child: const Text('Mark Delivered',
                                  style: TextStyle(
                                      color: Color(0xFF43A047), fontSize: 13))),
                        ),
                        const SizedBox(width: 10)
                      ]),
                    ],
                  ),
              ],
            ),
          )),
    );
  }
}
