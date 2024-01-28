import 'package:flutter/cupertino.dart';

class DisplayDimension {
  static final DisplayDimension dimension = DisplayDimension._init();
  late double screenWidth,
      screenHeight,
      smallDim,
      mediumDim,
      largeDim,
      xlargeDim,
      fieldHeight;
  DisplayDimension._init();

  factory DisplayDimension() {
    return dimension;
  }

  init(context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth < 400 && screenHeight < 600) {
      smallDim = 4.0;
      mediumDim = 6.0;
      largeDim = 8.0;
      xlargeDim = 14.0;
      fieldHeight = 40.0;
    } else {
      smallDim = 6.0;
      mediumDim = 8.0;
      largeDim = 10.0;
      xlargeDim = 20.0;
      fieldHeight = 50.0;
    }
  }
}
