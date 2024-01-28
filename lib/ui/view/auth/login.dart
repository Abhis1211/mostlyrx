import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/app_text_field.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/widgets/app_wrapper.dart';
import 'package:provider/provider.dart';

import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mailText = TextEditingController();
  final _passText = TextEditingController();
  final _mailKey = GlobalKey<FormFieldState>();
  final _passKey = GlobalKey<FormFieldState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 65),
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/app_logo.png')),
              AppTextField(
                  title: 'Email :',
                  hintText: 'Entre Email Address',
                  stateKey: _mailKey,
                  controller: _mailText,
                  validator: (val) =>
                      val != null && val.length > 3 && val.contains('@')
                          ? null
                          : 'Incorrect Mail'),
              const SizedBox(height: 10),
              AppTextField(
                  title: 'Password :',
                  hintText: 'Entre Password',
                  stateKey: _passKey,
                  controller: _passText,
                  isPassword: true,
                  validator: (val) => val != null && val.length > 3
                      ? null
                      : 'Please fille the password'),
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ForgotPassword()));
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color.fromRGBO(166, 166, 166, 1)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                          onPressed: _login,
                          child: const Text('SIGN IN',
                              style: TextStyle(
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
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_mailKey.currentState!.validate() &&
        _passKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        AuthenticationService service = Provider.of(context, listen: false);
        var response = await service.login(_mailText.text, _passText.text);
        setState(() {
          _isLoading = false;
        });
        if (response && mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const AppWrapperWidget()),
              ModalRoute.withName('/home'));
        }
      } on DioError catch (e) {
        Utils.showToast('Login Problem ${e.message}', Colors.white);
      }
    }
  }
}
