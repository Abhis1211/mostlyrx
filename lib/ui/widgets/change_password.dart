// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mostlyrx/ui/constants/shared_widgets.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
  String mail;
  ChangePassword({Key? key, required this.mail}) : super(key: key);
}

class _ChangePasswordState extends State<ChangePassword> {
  final _controllernewpassword = TextEditingController();
  final _controllerEmail = TextEditingController();
  var loginEmailError = TextEditingController();
  final _controllerconfirmpassword = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context);
    return Material(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: screensize.size.height * 0.35,
                alignment: Alignment.center,
                child: SharedWidgets.appLogo(),
              ),
              SizedBox(
                width: screensize.size.width * 0.75,
                child: SharedWidgets.roundtextinput5(
                    screensize.size.width * 0.85,
                    screensize.size.height * 0.08,
                    'Email',
                    _controllerEmail,
                    12.0, (text) {
                  if (text != '') {
                  } else {
                    setState(() {});
                  }
                }, ''),
              ),
              SizedBox(
                width: screensize.size.width * 0.75,
                child: SharedWidgets.roundtextinput5(
                    screensize.size.width * 0.85,
                    screensize.size.height * 0.08,
                    'New Password',
                    _controllernewpassword,
                    12.0, (text) {
                  if (text == '') {}
                }, ''),
              ),
              SizedBox(
                width: screensize.size.width * 0.75,
                child: SharedWidgets.roundtextinput5(
                    screensize.size.width * 0.85,
                    screensize.size.height * 0.08,
                    'Confirm Password',
                    _controllerconfirmpassword,
                    12.0,
                    (text) {},
                    ''),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
