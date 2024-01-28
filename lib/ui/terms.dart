import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/terms_text.dart';

class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  bool seleceted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 20),
            const Text(
              'Terms & Conditions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .75,
              child: const SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  termsText,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              )),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: seleceted,
                    onChanged: (val) {
                      setState(() {
                        seleceted = !seleceted;
                      });
                    }),
                const Text(
                  'I accept the Terms & Conditions',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
