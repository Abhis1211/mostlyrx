// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum DocumentType { DRIVER_LICENCE, PROVE }

class ImagePickerUtils {
  ImagePickerUtils._();

  static _imgFromGallery() async =>
      ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);

  static Future<XFile?> _imgFromCamera() async =>
      await ImagePicker().pickImage(source: ImageSource.camera);

  static Future<XFile?> showPicker(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        builder: (_) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      var res = await _imgFromGallery();
                      navigator.pop(res);
                    }),
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    var res = await _imgFromCamera();
                    navigator.pop(res);
                  },
                ),
              ],
            ),
          );
        });
  }

  static void showWaitDialog(String text, BuildContext context,
      {bool blockReturn = false}) {
    showDialog(
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () async => !blockReturn,
              child: SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                children: [
                  const SizedBox(height: 40),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 120),
                      child: CircularProgressIndicator()),
                  const SizedBox(height: 30),
                  Center(child: Text('$text.....')),
                  const SizedBox(height: 30),
                ],
              ),
            ));
  }
}
