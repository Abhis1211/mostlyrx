import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String? title;
  final String? message;
  final String? positiveBtnText;
  final String? negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double? circularBorderRadius;

  const CustomAlertDialog({
    Key? key,
    this.title,
    required this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText,
    this.negativeBtnText,
    this.onPostivePressed,
    this.onNegativePressed,
  })  : assert(circularBorderRadius != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: message != null ? Text(message!) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius!)),
      actions: <Widget>[
        negativeBtnText != null
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onNegativePressed != null) {
                    onNegativePressed!();
                  }
                },
                child: Text(negativeBtnText!),
              )
            : const SizedBox.shrink(),
        positiveBtnText != null
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onPressed: () {
                  if (onPostivePressed != null) {
                    onPostivePressed!();
                  }
                },
                child: Text(positiveBtnText!),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
