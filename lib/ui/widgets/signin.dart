import 'package:flutter/material.dart';
import 'package:mostlyrx/ui/constants/shared_widgets.dart';

class SignInWidget extends StatefulWidget {
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  const SignInWidget(
      {Key? key,
      required this.controllerEmail,
      required this.controllerPassword})
      : super(key: key);
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          SharedWidgets.appLogo(),
          const SizedBox(
            height: 50,
          ),
          SharedWidgets.roundTextField('Email Address', widget.controllerEmail),
          const SizedBox(
            height: 20,
          ),
          SharedWidgets.roundTextField('Password', widget.controllerPassword,
              isPassword: true),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
