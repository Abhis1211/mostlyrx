import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * .3,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/images/app_logo.png',
            ),
          ),
          const Spacer(),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: size.width,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF27AE60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.mail),
                        SizedBox(width: 10),
                        Text('Sign In',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'))
                      ]))),
          const SizedBox(height: 20),
          // Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 30),
          //     width: size.width,
          //     height: 60,
          //     child: ElevatedButton(
          //         onPressed: () async {
          //           Fluttertoast.showToast(msg: 'Coming soon!');
          //         },
          //         style: ButtonStyle(
          //             shadowColor:
          //                 MaterialStateProperty.all(Colors.transparent),
          //             backgroundColor:
          //                 MaterialStateProperty.all(const Color(0xFFF2F2F2)),
          //             shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(20)))),
          //         child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: const [
          //               Icon(Icons.facebook, color: Color(0xFF2F80ED)),
          //               SizedBox(width: 10),
          //               Text(
          //                 'Continue With Facebook',
          //                 style: TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                     color: Color(0xFF989E9A)),
          //               )
          //             ]))),

          // const SizedBox(height: 10),
          Text.rich(
            TextSpan(
                text: "Don't have account ?",
                style: const TextStyle(
                    fontFamily: 'Poppins', color: Color(0xFFACACAC)),
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushNamed(context, '/RegistrePage'),
                      text: '\tSign Up',
                      style: const TextStyle(
                          color: Color(0xFF27AE60),
                          fontWeight: FontWeight.bold,
                          fontSize: 15))
                ]),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
