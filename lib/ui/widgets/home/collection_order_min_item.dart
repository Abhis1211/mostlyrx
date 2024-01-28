import 'package:flutter/material.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/ui/constants/display.dart';
import 'package:mostlyrx/ui/constants/shared_widgets.dart';
import 'package:mostlyrx/ui/constants/styles.dart';

@Deprecated('NO NEED ANY MORE')
class OrderCollectionMinListItem extends StatelessWidget {
  final Order order;
  final Function onTapView;

  const OrderCollectionMinListItem(
      {Key? key, required this.order, required this.onTapView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.9,
      child: Container(
        height: 150,
        padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  order.pharmacy!.name!.toUpperCase(),
                  style: AppTextStyles.normal
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  getTotalDeliveryPrice(order.orderRequests!),
                  style: AppTextStyles.normal.copyWith(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 100,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 25,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: DisplayDimension().screenWidth * 0.65,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Pickup Address: ',
                                  style: AppTextStyles.normal
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: order.pharmacy!.address!,
                                  style: AppTextStyles.normal,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: DisplayDimension().screenWidth * 0.35,
                          child: Text(
                            Utils.getMyDate(order.createdAt.toString()),
                            style:
                                AppTextStyles.subtitle.copyWith(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                  DateTime.now().difference(order.createdAt!) <
                          const Duration(days: 1)
                      ? Positioned(
                          left: 10,
                          bottom: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            height: 30,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'New',
                                  style: AppTextStyles.normal
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: SizedBox(
                      width: 120,
                      height: 30,
                      child:
                          SharedWidgets.roundPrimaryButton('View', onTapView),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTotalDeliveryPrice(List<OrderRequest> orderRequests) {
    double totalEarning = 0;
    for (OrderRequest orderRequest in orderRequests) {
      totalEarning = totalEarning + orderRequest.deliveryPrice!;
    }
    return totalEarning.toString();
  }
}
