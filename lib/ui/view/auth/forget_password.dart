import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostlyrx/core/constants/app_text_field.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController controller = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 65),
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/app_logo.png')),
              const SizedBox(height: 65),
              AppTextField(
                  title: 'Email',
                  hintText: 'Entre your Email',
                  stateKey: _key,
                  validator: (val) =>
                      val != null && val.contains('@') ? null : 'Wrong mail',
                  controller: controller),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 260,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.all(8.0)),
                        onPressed: _sendPassword,
                        child: Text(
                          'Reset Password'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendPassword() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var webClient = http.Client();
      var response = await webClient.post(
          Uri.parse('https://mostlyrx.com/delivery/api/changePassword'),
          body: {'email': controller.text});
      setState(() {
        _isLoading = false;
      });

      if (jsonDecode(response.body)['code'] == 200) {
        await Fluttertoast.showToast(
            msg: 'User Password Reset Email sent',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.white,
            fontSize: 14.0);
        return;
      }
      await Fluttertoast.showToast(
          msg: 'Email Not found',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
