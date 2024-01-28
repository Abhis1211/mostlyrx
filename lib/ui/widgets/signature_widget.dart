import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:path_provider/path_provider.dart';

class SignaturePadWidget extends StatefulWidget {
  final OrdersViewModel model;

  const SignaturePadWidget(this.model, {Key? key}) : super(key: key);
  @override
  SignaturePadWidgetState createState() => SignaturePadWidgetState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8,
        Paint()..color = AppColors.primaryColor);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class SignaturePadWidgetState extends State<SignaturePadWidget> {
  ByteData _img = ByteData(0);
  var color = Colors.red;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Board'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign,
                  backgroundPainter: _WatermarkPaint('2.0', '2.0'),
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
          ),
          _img.buffer.lengthInBytes == 0
              ? Container()
              : LimitedBox(
                  maxHeight: 200.0,
                  child: Image.memory(_img.buffer.asUint8List())),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      color: Colors.green,
                      onPressed: () async {
                        final sign = _sign.currentState;
                        final image = await sign!.getData();
                        var data = await image.toByteData(
                            format: ui.ImageByteFormat.png);
                        sign.clear();
                        File? file = await writeToFile(data!);
                        if (mounted) {
                          if (file != null) {
                            Navigator.of(context).pop(file);
                          } else {
                            Utils.showToast('Please Try Again', Colors.red);
                            Utils.showAlert(
                                context, 'Unsuccessful', 'Please Try Again');
                          }
                        }
                      },
                      child: const Text('Save')),
                  MaterialButton(
                      color: Colors.grey,
                      onPressed: () {
                        final sign = _sign.currentState;
                        sign!.clear();
                        setState(() {
                          _img = ByteData(0);
                        });
                        debugPrint('cleared');
                      },
                      child: const Text('Clear')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          color =
                              color == Colors.green ? Colors.red : Colors.green;
                        });
                        debugPrint('change color');
                      },
                      child: const Text('Change color')),
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          int min = 1;
                          int max = 10;
                          int selection = min + (Random().nextInt(max - min));
                          strokeWidth = selection.roundToDouble();
                        });
                      },
                      child: const Text('Change stroke width')),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<File?> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        '$tempPath/file_01.jpg'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
