import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/ui/constants/colors.dart';

class SharedWidgets {
  static appLogo() {
    return Image.asset(
      'assets/images/app_logo.png',
      width: Utils.dimensions!.width * 0.7,
    );
  }

  static appLogoSm() {
    return Image.asset(
      'assets/images/app_logo_sm.png',
      width: Utils.dimensions!.width * 0.2,
    );
  }

  static roundPWhiteButton(String text, onPressed,
      {double width = 0, double height = 0}) {
    return Container(
      width: width == 0 ? Utils.dimensions!.width : width,
      height: height == 0 ? 60 : height,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(color: Colors.grey)),
            padding: const EdgeInsets.all(8.0)),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(fontSize: 14.0, color: AppColors.primaryColor),
        ),
      ),
    );
  }

  static roundTextField(String hint, TextEditingController controller,
      {double width = 0, bool isPassword = false}) {
    return Container(
        width: width == 0 ? Utils.dimensions!.width : width,
        height: 60,
        margin: const EdgeInsets.only(left: 8, right: 8),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              filled: true,
              contentPadding: const EdgeInsets.all(20),
              hintStyle: const TextStyle(
                color: AppColors.secondFontColor,
              ),
              hintText: hint,
              fillColor: Colors.white70),
        ));
  }

  static roundPrimaryButton(String text, onPressed,
      {double width = 0, double height = 0}) {
    return Container(
      width: width == 0 ? Utils.dimensions!.width : width,
      height: height == 0 ? 60 : height,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: AppColors.primaryColor),
            )),
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            textStyle:
                MaterialStateProperty.all(const TextStyle(color: Colors.white)),
            padding: MaterialStateProperty.all(const EdgeInsets.all(8.0))),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  static roundPrimaryButton2(String text, onPressed, color,
      {double width = 0, double height = 0}) {
    return Container(
      width: width == 0 ? Utils.dimensions!.width : width,
      height: height == 0 ? 60 : height,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(color: Colors.black38),
            ),
            textStyle: const TextStyle(color: Colors.white),
            padding: const EdgeInsets.all(4.0)),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  static roundPrimaryButton3(String text, Color textcolor,
      VoidCallback onPressed, Color color, double fontsize,
      {double width = 0,
      double height = 0,
      Color? borderColor,
      TextStyle? textStyle}) {
    return Container(
      width: width == 0 ? Utils.dimensions!.width : width,
      height: height == 0 ? 60 : height,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: borderColor ?? color),
            ),
            backgroundColor: color,
            shadowColor: Colors.transparent,
            textStyle: TextStyle(color: textcolor),
            padding: const EdgeInsets.all(4.0)),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                  fontSize: fontsize, color: textcolor, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  static outlinePrimaryButton4(String text, Color textcolor,
      VoidCallback onPressed, Color color, double fontsize,
      {double width = 0,
        double height = 0,
        Color? borderColor,
        TextStyle? textStyle}) {
    return Container(
      width: width == 0 ? Utils.dimensions!.width : width,
      height: height == 0 ? 60 : height,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor ?? color,width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: borderColor ?? color),
            ),

            shadowColor: Colors.transparent,
            textStyle: TextStyle(color: textcolor),
            padding: const EdgeInsets.all(4.0)),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                  fontSize: fontsize, color: textcolor, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  static roundPWhiteButton2(String text, onPressed,
      {double width = 0, double height = 0}) {
    return Container(
      width: width == 0 ? Utils.dimensions!.width : width,
      height: height == 0 ? 60 : height,
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(color: Colors.grey)),
            backgroundColor: Colors.white,
            textStyle: const TextStyle(color: AppColors.primaryColor),
            padding: const EdgeInsets.all(4.0)),
        onPressed: () {
          onPressed();
        },
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  //change

  static roundtextinput1(
      double width,
      double height,
      String hinttext,
      TextEditingController controller,
      double fontsize,
      validatorr,
      keyboardtype) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20.0),
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        validator: validatorr,
        keyboardType: keyboardtype,
        style: TextStyle(
          fontSize: fontsize,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: fontsize),
        ),
      ),
    );
  }

  static roundtextinput2(
      double width,
      double height,
      String hinttext,
      TextEditingController controller,
      double fontsize,
      validatorr,
      keyboardtype) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20.0),
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        validator: validatorr,
        keyboardType: keyboardtype,
        obscureText: true,
        style: TextStyle(
          fontSize: fontsize,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: fontsize),
        ),
      ),
    );
  }

  static roundtextinput3(
      double width,
      double height,
      String hinttext,
      TextEditingController controller,
      double fontsize,
      validatorr,
      keyboardtype) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20.0),
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        validator: validatorr,
        keyboardType: keyboardtype,
        style: TextStyle(
          fontSize: fontsize,
        ),
        decoration: InputDecoration(
          suffixText: ('(lbs)'),
          contentPadding: const EdgeInsets.all(10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: fontsize),
        ),
      ),
    );
  }

  static roundtextinput(
    double width,
    double height,
    String hinttext,
    TextEditingController controller,
    double fontsize,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20.0),
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: fontsize,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: fontsize),
        ),
      ),
    );
  }

  static roundtextinput5(
    double width,
    double height,
    String hinttext,
    TextEditingController controller,
    double fontsize,
    onChanged,
    String text,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20.0),
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: fontsize,
        ),
        decoration: InputDecoration(
          errorText: text,
          contentPadding: const EdgeInsets.all(10.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          hintText: hinttext,
          hintStyle: TextStyle(fontSize: fontsize),
        ),
      ),
    );
  }

  static roundbutton(String text, double width, double heigth, background,
      fontsize, onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontsize,
          color: Colors.white,
        ),
      ),
    );
  }

//change

}
