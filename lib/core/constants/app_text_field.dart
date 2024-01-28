import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mostlyrx/ui/constants/colors.dart';

class AppTextField extends StatefulWidget {
  final String title;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isPassword;
  final bool showFlage;
  final Key? stateKey;
  final int? max;
  final List<TextInputFormatter>? inputFormate;
  const AppTextField(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.controller,
      this.stateKey,
      this.validator,
      this.isPassword = false,
      this.showFlage = false,
      this.max,
      this.inputFormate,
      this.textInputType = TextInputType.text})
      : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _visible;
  @override
  void initState() {
    super.initState();
    _visible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: _visible,
              keyboardType: widget.textInputType,
              controller: widget.controller,
              validator: widget.validator ??
                  (val) => val!.isNotEmpty ? null : 'Please Fill This filed',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: widget.max,
              inputFormatters: widget.inputFormate,
              key: widget.stateKey,
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
                fillColor: Colors.white,
                filled: true,
                prefixIcon: widget.showFlage
                    ? SizedBox(
                        width: 63,
                        child: Row(
                          children: [
                            const SizedBox(width: 7),
                            Image.asset('assets/icons/canada.png',
                                width: 30, height: 30),
                            const SizedBox(width: 5),
                            const Text('+1')
                          ],
                        ),
                      )
                    : null,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: _getBorder,
                border: _getBorder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _getBorder => OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(18));
}
