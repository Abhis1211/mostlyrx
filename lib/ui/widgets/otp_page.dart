import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  StringBuffer otpCode = StringBuffer();
  int _secondLeft = 120;
  final int _step = 60;
  Timer? timer;
  late AuthenticationService authService;
  bool isLoading = false;
  bool smsSent = false;
  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthenticationService>(context, listen: false);
    initData();
  }

  initData() async {
    var pref = await SharedPreferences.getInstance();
    var assignedTime = pref.getString('sendtime');
    var oldPhoneNumber = pref.getString('number');
    if (assignedTime == null || assignedTime.isEmpty) {
      setState(() {
        _secondLeft = _step;
        smsSent = false;
      });
      await pref.setString(
          'sendtime', DateTime.now().millisecondsSinceEpoch.toString());
      await pref.setString('number', widget.phoneNumber);
      if (mounted) {
        await authService.sendSMS(widget.phoneNumber, context, (value) {
          setState(() {
            smsSent = value;
          });
        });
      }
    } else {
      if (oldPhoneNumber != widget.phoneNumber) {
        Fluttertoast.showToast(
            textColor: Colors.white,
            backgroundColor: Colors.black,
            msg:
                'Please wait until time finish to send to a new number SMS has been sent to +1$oldPhoneNumber',
            toastLength: Toast.LENGTH_LONG);
      }

      setState(() {
        _secondLeft = _step -
            DateTime.now()
                .difference(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(assignedTime)))
                .inSeconds;
        smsSent = true;
      });
    }

    countDownTimer();
  }

  void countDownTimer() {
    if (_secondLeft <= 0) {
      cancelCountDown();
      return;
    }
    if (timer != null && timer!.isActive) timer!.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          --_secondLeft;
          if (_secondLeft <= 0) {
            cancelCountDown();
          }
        });
      }
    });
  }

  void cancelCountDown() async {
    if (timer != null && timer!.isActive) timer!.cancel();
    (await SharedPreferences.getInstance()).setString('sendtime', '');
    _secondLeft = 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AuthenticationService>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: const Color(0xFF129D4C),
        body: Stack(
          children: [
            Positioned(
                top: kToolbarHeight + 10,
                left: 10,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.white))),
            Positioned(
                top: kToolbarHeight + 50,
                child: SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Please enter the 6 digit OTP\n sent to +1 $formatedNumber',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              6, (index) => numContainer(getNumber(index)))),
                      const SizedBox(height: 10),
                      const Text("Don't tell anyone this code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0XFFF2F2F2), fontSize: 13)),
                      if (_secondLeft != 0) const SizedBox(height: 10),
                      if (_secondLeft != 0)
                        Text('You can resend Code In $formateSecond',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0XFFF2F2F2), fontSize: 13)),
                      if (_secondLeft == 0)
                        TextButton(
                            onPressed: () async {
                              initData();
                            },
                            child: const Text(
                              "You didn't receive ? Send Again",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white),
                            ))
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: size.width,
                    height: size.height * .57,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GridView.count(
                            reverse: true,
                            shrinkWrap: true,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                            childAspectRatio: 16 / 11,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              numbButton('C', setVal: (val) {
                                setState(() {
                                  otpCode.clear();
                                });
                              }),
                              numbButton('0'),
                              InkWell(
                                onTap: () {
                                  if (otpCode.isNotEmpty) {
                                    setState(() {
                                      var newVal = otpCode
                                          .toString()
                                          .substring(0, otpCode.length - 1);
                                      otpCode.clear();
                                      otpCode.write(newVal);
                                    });
                                  }
                                },
                                child: const Icon(Icons.backspace_rounded,
                                    size: 30, color: Colors.white),
                              ),
                              ...List.generate(
                                  9,
                                  (index) => numbButton(
                                        '${index + 1}',
                                      ))
                            ],
                          ),
                          Container(
                            width: size.width * .75,
                            margin: const EdgeInsets.only(bottom: 10, top: 10),
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isLoading || !smsSent
                                  ? () {}
                                  : () async {
                                      if (otpCode.length < 6) {
                                        Fluttertoast.showToast(
                                            msg: 'Wrong OTP code');
                                        return;
                                      }
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await authService.verfiePhoneNumber(
                                          otpCode.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              child: Text(
                                isLoading
                                    ? 'Verifying....'
                                    : smsSent
                                        ? 'Continue'
                                        : 'Sending sms...',
                                style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Widget numbButton(String text, {ValueSetter<String>? setVal}) => InkWell(
        onTap: () {
          if (setVal != null) {
            setVal(text);
            return;
          }
          if (otpCode.length < 6) {
            otpCode.write(text);
            setState(() {});
            return;
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 26),
          ),
        ),
      );

  Widget numContainer(String text) => Container(
        width: MediaQuery.of(context).size.width / 6 - 20,
        height: 50,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Text(
          text,
          style: const TextStyle(fontSize: 32),
        ),
      );

  String getNumber(int index) {
    if (otpCode.isEmpty || otpCode.length <= index) return '';
    return otpCode.toString().characters.elementAt(index);
  }

  String get formateSecond {
    var numberFormatter = NumberFormat('#00');
    if (_secondLeft >= 120) {
      return '02:${numberFormatter.format(_secondLeft - 120)}';
    }
    if (_secondLeft >= 60) {
      return '01:${numberFormatter.format(_secondLeft - 60)}';
    }
    return '00:${numberFormatter.format(_secondLeft)}';
  }

  String get formatedNumber =>
      '(${widget.phoneNumber.substring(0, 3)}) ${widget.phoneNumber.substring(3, 6)}-${widget.phoneNumber.substring(6, 10)}';
}
