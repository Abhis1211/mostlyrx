import 'package:flutter/material.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/display.dart';
import 'package:mostlyrx/ui/constants/shared_widgets.dart';
import 'package:mostlyrx/ui/constants/styles.dart';

class ListingsWidget extends StatefulWidget {
  const ListingsWidget({Key? key}) : super(key: key);

  @override
  State<ListingsWidget> createState() => _ListingsWidgetState();
}

class _ListingsWidgetState extends State<ListingsWidget> {
  @override
  Widget build(BuildContext context) {
    DisplayDimension().init(context);
    return ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return listingItem();
        });
  }

  listingItem() {
    return Card(
      elevation: 0.9,
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'MEDICAL COMPLEX',
                  style: AppTextStyles.normal
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$55',
                  style: AppTextStyles.normal.copyWith(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 150,
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    left: 1,
                    child: Icon(
                      Icons.radio_button_checked,
                      size: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    left: 7,
                    top: 14,
                    child: Container(
                      height: 37,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 2, color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 1,
                    top: 50,
                    child: Icon(
                      Icons.radio_button_checked,
                      size: 15,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    left: 25,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: DisplayDimension().screenWidth * 0.68,
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Pickup Address: ',
                                  style: AppTextStyles.normal
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                  text:
                                      '401 Broaddus Avenue Pleasant Bridge KY 407669',
                                  style: AppTextStyles.normal,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text('21/05/2020',
                            style:
                                AppTextStyles.subtitle.copyWith(fontSize: 12))
                      ],
                    ),
                  ),
                  Positioned(
                    left: 25,
                    top: 50,
                    child: SizedBox(
                      width: DisplayDimension().screenWidth * 0.7,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Delivery Address:',
                                    style: AppTextStyles.normal
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text:
                                        '401 Broaddus Avenue Pleasant Bridge KY 407669',
                                    style: AppTextStyles.normal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 100,
                    bottom: 20,
                    child: SizedBox(
                      width: 120,
                      height: 30,
                      child: SharedWidgets.roundPrimaryButton('ASSIGN', null),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 20,
                    child: SizedBox(
                      width: 120,
                      height: 30,
                      child: SharedWidgets.roundPWhiteButton('IGNORE', null),
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
}
