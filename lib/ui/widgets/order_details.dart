import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/constants/icons.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/display.dart';
import 'package:mostlyrx/ui/constants/shared_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/models/user.dart';

class OrderDetailsWidget extends StatefulWidget {
  final Order _order;
  static bool clicked = false;
  const OrderDetailsWidget(this._order, {Key? key}) : super(key: key);

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  bool isNotCompleted = true;
  @override
  void initState() {
    isNotCompleted = widget._order.orderStatus != 'complete';
    if (mounted) {
      OrderDetailsWidget.clicked = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DisplayDimension().init(context);
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (OrderDetailsWidget.clicked) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false,
              arguments: 1);
        } else {
          Navigator.of(context).pop();
        }
        return true;
      },
      child: Material(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                shadowColor: const Color(0xFFF3F3F3),
                title: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.16),
                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Stops   '.toUpperCase(),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xff1EA256),
                              fontWeight: FontWeight.w700,
                              fontSize: 20)),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: const Color(0xffFFCD00),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          '${widget._order.totalStops.toString()=='null'?widget._order.orderRequests!.length:widget._order.totalStops}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    if (OrderDetailsWidget.clicked) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false,
                          arguments: 1);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios,
                      size: 25, color: AppColors.primaryColor),
                ),
              ),
              body: Stack(
                children: [
                  Positioned(
                      bottom: 0,
                      child: Image.asset('assets/vectors/Vector 1.png',
                          width: size.width, fit: BoxFit.fitWidth)),
                  Positioned(
                      bottom: size.height * .5,
                      child: Image.asset('assets/vectors/vector 3.png')),
                  Positioned(
                      bottom: 0,
                      child: Image.asset('assets/vectors/Vector 2.png')),
                  // widget._order.orderRequests!.isEmpty && !checkIfComplete()
                  //     ? const Center(
                  //         child: Text('This order has no deliveries!!'))
                  //     : Column(
                  //         children: [
                  //           SizedBox(
                  //             height: MediaQuery.of(context).size.height - 114,
                  //             width: MediaQuery.of(context).size.width,
                  //             child: ListView.builder(
                  //               shrinkWrap: true,
                  //               itemCount: widget._order.orderRequests!.length,
                  //               scrollDirection: Axis.horizontal,
                  //               itemBuilder: (context, index) {
                  //                 return OrderItem(
                  //                     index: index,
                  //                     orderRequest:
                  //                         widget._order.orderRequests![index],
                  //                     order: widget._order);
                  //               },
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                ],
              ),
            ),

            ///
            IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(top: kTextTabBarHeight - 10),
                child: Image.asset(
                  'assets/vectors/Vector 4.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            ///
            widget._order.orderRequests!.isEmpty && !checkIfComplete()
                ? const Center(child: Text('This order has no deliveries!!'))
                : Padding(
                    padding: EdgeInsets.only(top: size.height * 0.15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget._order.orderRequests!.length,
                      controller: scrollController2,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return OrderItem(
                            index: index,
                            orderRequest: widget._order.orderRequests![index],
                            order: widget._order);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
  ScrollController scrollController2=ScrollController();

  checkIfComplete() {
    if (widget._order.orderStatus == 'pending') {
      return true;
    } else if (widget._order.orderStatus == 'accepted') {
      return false;
    } else {
      return (widget._order.orderStatus == 'cancelled' ||
          widget._order.orderStatus == 'complete');
    }
  }
}

class OrderItem extends StatefulWidget {
  final int index;
  final OrderRequest orderRequest;
  final Order order;
  const OrderItem({
    Key? key,
    required this.index,
    required this.orderRequest,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isNotCompleted = true;
  num distanceBettwen = 0;

  @override
  void initState() {
    setState(() {
      distanceBettwen = widget.orderRequest.distanceBetween(
          double.tryParse(widget.order.pharmacy!.latitude!) ?? 0,
          double.tryParse(widget.order.pharmacy!.longitude!) ?? 0);
    });
    isNotCompleted = widget.order.orderStatus != 'complete';
    super.initState();
  }

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

  final color = const Color(0xff1EA256);
  ScrollController scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        shrinkWrap: true,
        controller: scrollController,
        children: [
          /// first
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// address and stop
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Address : ',
                        style: poppinsSemiBold.copyWith(
                          fontSize: 16,
                          color: AppColors.blueColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Stop ',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 16,
                              color: AppColors.greyText,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.index + 1}',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 16,
                              color: AppColors.blueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (distanceBettwen != -1)
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    text: distance.split(' ').last)
                              ],
                              text: '${distance.split(' ').first} ',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (distanceBettwen != -1)
                            Image.asset(
                              AppIcons.distance1,
                              width: 28,
                              height: 28,
                            ),
                        ],
                      ),
                  ],
                ),

                ///
                Text(
                  '${widget.order.pharmacy!.name}',
                  overflow: TextOverflow.clip,
                  style: poppinsBold.copyWith(
                    fontSize: 20,
                    color: AppColors.primaryOneColor,
                  ),
                ),
                const SizedBox(height: 12),

                ///
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup Address',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 13,
                              color: AppColors.greenLight,
                            ),
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .7,
                            child: Text(
                              '${widget.orderRequest.from_address}',
                              style: poppinsRegular.copyWith(
                                fontSize: 13,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('START'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'GLODBENOON',
                  overflow: TextOverflow.clip,
                  style: poppinsBold.copyWith(
                    fontSize: 15,
                    color: AppColors.primaryOneColor,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          /// second
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///
                Text(
                  '${widget.orderRequest.customerName}',
                  overflow: TextOverflow.clip,
                  style: poppinsBold.copyWith(
                    fontSize: 20,
                    color: AppColors.primaryOneColor,
                  ),
                ),

                ///
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 13,
                              color: AppColors.greenLight,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.orderRequest.address}',
                            style: poppinsRegular.copyWith(
                              fontSize: 13,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Finish'),
                    )
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),

          /// calls button
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (widget.orderRequest.contact == null) {
                      Utils.showToast('No Contact Number', Colors.black);
                      return;
                    }
                    String phone = widget.orderRequest.contact!;
                    if (await canLaunchUrlString('tel:$phone')) {
                      await launchUrl(Uri.parse('tel:$phone'));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.greenLight,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppIcons.phone),
                        const SizedBox(width: 4.0),
                        Text(
                          'Call Customer',
                          style: poppinsMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (widget.order.pharmacy?.phone == null) {
                      Utils.showToast('No Company Number', Colors.black);
                      return;
                    }
                    String phone = widget.order.pharmacy!.phone!;
                    if (await canLaunchUrlString('tel:$phone')) {
                      await launchUrlString('tel:$phone');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.greenLight,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppIcons.phone),
                        const SizedBox(width: 4.0),
                        Text(
                          'Call Company',
                          style: poppinsMedium.copyWith(
                            fontSize: 14,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          ///
          const SizedBox(height: 10),
          Text(
            'Notes :',
            style: poppinsSemiBold.copyWith(
              fontSize: 16,
              color: AppColors.primaryOneColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: height * 0.12,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.greenLight,
                width: 1.0,
              ),
            ),
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.orderRequest.notes??'',
                contentPadding: const EdgeInsets.only(left: 16),
                hintStyle: poppinsRegular.copyWith(
                  fontSize: 12,
                  color: AppColors.blueColor,
                ),
              ),
            ),
          ),

          ///
          const SizedBox(height: 16),
          Card(
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  _infoText('Your Earnings',
                      '\$${widget.orderRequest.deliveryPrice?.toStringAsFixed(2)}',
                      defaultColor: Colors.blue),
                  _infoText(
                      'Delivery Date : ',
                      DateFormat.yMMMd().format(
                          widget.orderRequest.createdAt ?? DateTime.now())),
                  _infoText('Customer pays',
                      '\$${double.tryParse(widget.orderRequest.orderPrice ?? '0')?.toStringAsFixed(2)}',
                      defaultColor: Colors.blue),
                ],
              ),
            ),
          ),
          if (isNotCompleted) const SizedBox(height: 20),
          if (isNotCompleted)
            SharedWidgets.roundPrimaryButton3(
              'Proceed To Pickup',
              Colors.white,
              () async {
                await Utils.navigate(
                  endPoint: LatLng(
                    double.parse(widget.order.pharmacy!.latitude!),
                    double.parse(widget.order.pharmacy!.longitude!),
                  ),
                );
              },
              const Color(0xFF828282),
              14.0,
              width: DisplayDimension().screenWidth * 0.85,
              height: 60,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 20),
          if (isNotCompleted)
            Column(
              children: [
                SharedWidgets.roundPrimaryButton3(
                    'Proceed to drop off', Colors.white, () {
                  Navigator.of(context)
                      .pushNamed('/map_view', arguments: widget.order);
                }, AppColors.primaryColor, 14.0,
                    width: DisplayDimension().screenWidth * 0.85,
                    height: 50,
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SharedWidgets.outlinePrimaryButton4(
                  'Cancel',
                  Colors.red,
                  () async {
                    if (OrderDetailsWidget.clicked) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home', (Route<dynamic> route) => false);
                    } else {
                      print("its here");
                      var _user = Provider.of<User>(context, listen: false);
                      print(_user.id);
                      OrdersViewModel orderview = OrdersViewModel(
                          orderService: Provider.of(context, listen: false));
                      var resp = await orderview.rejectOrder(
                          -1, _user.id.toString(),
                          order: widget.order);
                      if (resp ?? false) {
                        Navigator.of(Constants
                                .appNavigationKey.currentState!.context)
                            .pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false,
                                arguments: 1);
                      }
                      print(resp);
//                  Navigator.of(context).pop();
                    }
                  },
                  Colors.red,
                  14.0,
                  width: DisplayDimension().screenWidth * 0.85,
                  height: 50,
                  borderColor: const Color(0xffFF0000),
                  textStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _infoText(String discrption, String? data,
          {Color defaultColor = const Color(0xFF717171)}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              discrption,
              style: poppinsMedium.copyWith(
                fontSize: 15,
                color: AppColors.primaryOneColor,
              ),
            ),
            Flexible(
              child: Text(
                '$data',
                style: poppinsBold.copyWith(
                  fontSize: 15,
                  color: defaultColor,
                ),
              ),
            )
          ],
        ),
      );
}
