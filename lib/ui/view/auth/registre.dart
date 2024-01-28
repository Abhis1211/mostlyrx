import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostlyrx/core/constants/app_text_field.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/ui/constants/colors.dart';

class RegistrePage extends StatefulWidget {
  const RegistrePage({Key? key}) : super(key: key);

  @override
  State<RegistrePage> createState() => _RegistrePageState();
}

class _RegistrePageState extends State<RegistrePage> {
  final _nameText = TextEditingController();
  final _addressText = TextEditingController();
  final _phoneText = TextEditingController();
  final _mailText = TextEditingController();
  final _passText = TextEditingController();
  final _pass2Text = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool canWork = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[100],
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/images/app_logo.png')),
                AppTextField(
                    title: 'Name :',
                    hintText: 'Entre Full Name',
                    controller: _nameText),
                const SizedBox(height: 10),
                AppTextField(
                    title: 'Email :',
                    hintText: 'Entre Email Address',
                    controller: _mailText,
                    validator: (val) => val != null &&
                            RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val.trim())
                        ? null
                        : 'Incorrect Mail'),
                const SizedBox(height: 10),
                AppTextField(
                    title: 'Address :',
                    hintText: 'Entre Permanent Address',
                    controller: _addressText),
                const SizedBox(height: 10),
                AppTextField(
                    title: 'Phone Number :',
                    hintText: 'Entre Contact Number',
                    textInputType: const TextInputType.numberWithOptions(),
                    inputFormate: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                    showFlage: true,
                    validator: (val) =>
                        val!.length != 10 ? 'Wrong Number phone' : null,
                    controller: _phoneText),
                const SizedBox(height: 10),
                AppTextField(
                    title: 'Password :',
                    hintText: 'Entre Password',
                    controller: _passText,
                    isPassword: true,
                    validator: (val) => val != null && val.length > 3
                        ? null
                        : 'Please fille the password'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 115,
                  child: AppTextField(
                      title: 'Confirm Password :',
                      hintText: 'Entre Password',
                      controller: _pass2Text,
                      isPassword: true,
                      validator: (val) =>
                          val != null && _pass2Text.text == _passText.text
                              ? null
                              : 'Passowrd dosn\'t Match'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: canWork,
                        contentPadding: EdgeInsets.zero,
                        title:
                            const Text('Yes I am eligible to work in Canada'),
                        onChanged: (val) {
                          setState(() {
                            canWork = val!;
                          });
                        }),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: 260,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.all(8.0)),
                        onPressed: _registre,
                        child: Text('register'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)))),
                const SizedBox(height: 20),
                Text.rich(TextSpan(
                    text: 'By Signing in you agree to ',
                    style: const TextStyle(fontSize: 13),
                    children: [
                      TextSpan(
                          text: 'Terms & Conditions',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed('/terms');
                            },
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14))
                    ])),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _registre() async {
    if (canWork) {
      if (_formKey.currentState!.validate()) {
        AuthenticationService.registredInfo = jsonEncode({
          'name': _nameText.text,
          'password': _passText.text,
          'email': _mailText.text,
          'address': _addressText.text,
          'contact': _phoneText.text,
          'latitude': 0,
          'longitude': 0,
          'token': ''
        });
        Navigator.of(context).pushNamed('/otp', arguments: _phoneText.text);
      }
    } else {
      Fluttertoast.showToast(msg: 'Sorry this only for canadian pople');
    }
  }
}
