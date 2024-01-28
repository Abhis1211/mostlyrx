import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextFieldV2 extends StatefulWidget {
  final String title;
  final String hintText;
  final FormFieldValidator<String>? validator;

  final TextInputType textInputType;
  final bool isPassword;

  final Key? stateKey;
  const AppTextFieldV2(
      {Key? key,
      required this.title,
      required this.hintText,
      this.stateKey,
      this.validator,
      this.isPassword = false,
      this.textInputType = TextInputType.text})
      : super(key: key);

  @override
  State<AppTextFieldV2> createState() => _AppTextFieldV2State();
}

class _AppTextFieldV2State extends State<AppTextFieldV2> {
  late bool _visible;
  @override
  void initState() {
    super.initState();
    _visible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.title,
                  style: const TextStyle(
                      color: Color(0xFF43A047),
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextFormField(
                key: widget.stateKey,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(color: Color(0xFF747474)),
                controller: TextEditingController(text: widget.hintText),
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(_visible
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash),
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          })
                      : null,
                  fillColor: const Color(0XFFF4F4F4),
                  filled: true,
                  enabledBorder: _getBorder,
                  border: _getBorder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _getBorder => OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(18));
}
