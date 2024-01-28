// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mostlyrx/core/apimodels/earnings_response.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/display.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
@Deprecated('STUPIIIIIIIIIIIIIIIIIIID')
class EarningsWidget extends StatelessWidget {
  Earnings earnings;
  EarningsWidget(this.earnings, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DisplayDimension dimension = DisplayDimension();
    dimension.init(context);
    double leftMargin = dimension.screenWidth / 7;
    double circleSize = dimension.screenWidth * .7;
    double marginTop = dimension.screenHeight * 0.1;
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: leftMargin,
            top: marginTop,
            child: Container(
              height: circleSize,
              width: circleSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circleSize),
                border: Border.all(
                    width: 5,
                    color: Colors.grey[300]!,
                    style: BorderStyle.solid),
              ),
            ),
          ),
          Positioned(
            left: leftMargin + 7,
            top: marginTop + 7,
            child: Container(
              height: circleSize - 15,
              width: circleSize - 15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circleSize),
                border: Border.all(
                    width: 5,
                    color: AppColors.primaryColor,
                    style: BorderStyle.solid),
              ),
            ),
          ),
          Positioned(
            left: leftMargin + 12,
            top: marginTop + 7 + 5,
            child: Container(
              height: circleSize - 25,
              width: circleSize - 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circleSize),
                border: Border.all(
                    width: 20,
                    color: Colors.grey[300]!,
                    style: BorderStyle.solid),
              ),
            ),
          ),
          Positioned(
            left: leftMargin + 30,
            top: marginTop + 30,
            child: Container(
                height: circleSize - 60,
                width: circleSize - 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(circleSize),
                  color: AppColors.primaryColor,
                  border: Border.all(
                      width: 10,
                      color: AppColors.primaryColor,
                      style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      earnings.currentMonthEarnedAmount,
                      style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Center(
                          child: Text(
                        'Earnings of this Month',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle
                            .copyWith(color: Colors.white, fontSize: 18),
                      )),
                    ),
                  ],
                )),
          ),
          Positioned(
            bottom: 20,
            left: dimension.screenWidth / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  earnings.totalEarning,
                  style: AppTextStyles.heading.copyWith(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Total Earnings',
                  style: AppTextStyles.heading,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
