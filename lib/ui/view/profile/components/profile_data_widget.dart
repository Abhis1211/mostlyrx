import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/styles.dart';

class ProfileDataWidget extends StatelessWidget {
  final bool? isBorder;
  final String heading;
  final String valueText;

  const ProfileDataWidget({
    super.key,
    this.isBorder = true,
    required this.heading,
    required this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: height * 0.02),
      padding: const EdgeInsets.only(bottom: 10),
      decoration:  BoxDecoration(
        border: isBorder == true ? const Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 0.6,
          ),
        ) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
            style: poppinsRegular.copyWith(
              fontSize: 14,
              color: AppColors.greyText,
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            valueText,
            style: poppinsMedium.copyWith(
              fontSize: 16,
              color: AppColors.primaryOneColor,
            ),
          ),
        ],
      ),
    );
  }
}
