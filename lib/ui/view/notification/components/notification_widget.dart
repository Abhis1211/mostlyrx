import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors.dart';
import '../../../constants/icons.dart';
import '../../../constants/styles.dart';

class NotificationWidget extends StatelessWidget {
  final String iconPath;
  final String heading;
  final String timeText;
  final String description;

  const NotificationWidget({
    super.key,
    required this.iconPath,
    required this.heading,
    required this.timeText,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.05,
            width: size.height * 0.05,
            decoration: BoxDecoration(
              color: AppColors.greyScale50,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Center(child: SvgPicture.asset(iconPath, height: 24, width: 24, fit: BoxFit.fill),),
          ),
          SizedBox(width: size.height * 0.016),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        heading,
                        style: poppinsMedium.copyWith(
                          fontSize: 16,
                          color: AppColors.greyScale900,
                        ),
                      ),
                    ),
                    Text(
                      timeText,
                      style: poppinsRegular.copyWith(
                        fontSize: 12,
                        color: AppColors.greyScale500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: poppinsRegular.copyWith(
                    fontSize: 12,
                    color: AppColors.blueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
