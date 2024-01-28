import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontFamily: 'SourceSansPro',
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    color: AppColors.mainFontColor,
  );
  static const normal = TextStyle(
    fontFamily: 'SourceSansPro',
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.mainFontColor,
  );

  static const subtitle = TextStyle(
    fontFamily: 'SourceSansPro',
    fontSize: 13.0,
    fontWeight: FontWeight.w300,
    color: AppColors.secondFontColor,
  );


}

TextStyle poppinsBold = GoogleFonts.poppins(
  fontWeight: FontWeight.w700,
);

TextStyle appBarTitleStyle = GoogleFonts.poppins(
  fontWeight: FontWeight.w600,
  color: AppColors.primaryOneColor,
  fontSize: 18,
);

TextStyle poppinsSemiBold = GoogleFonts.poppins(
  fontWeight: FontWeight.w600,
);

TextStyle poppinsMedium = GoogleFonts.poppins(
  fontWeight: FontWeight.w500,
);

TextStyle poppinsRegular = GoogleFonts.poppins(
  fontWeight: FontWeight.w400,
);