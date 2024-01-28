import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as int_ilib;
import 'package:intl/intl.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:io';

class Utils {
  static Size? dimensions;
  static BuildContext? context;
  init(context) {
    dimensions = MediaQuery.of(context).size;
    context = context;
  }

  static showMessageDialoge(String message) async {
    showGeneralDialog(
        context: Constants.appNavigationKey.currentState!.context,
        pageBuilder: (context, animation, secondaryAnimation) => SimpleDialog(
              title: Text(message),
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'))
              ],
            ));
  }

  static getDate(DateTime input) {
    return int_ilib.DateFormat('yyyy-MM-dd').format(input);
  }

  static void showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 20),
      action: SnackBarAction(
        label: 'View',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  }

  static showAlert(BuildContext context, String title, String msg) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(msg),
            ));
  }

  // static Future<BitmapDescriptor> createCustomMarkerBitmap(
  //     BuildContext context, String title,
  //     {required Color bgColor}) async {
  //   TextSpan span = TextSpan(
  //     style: AppTextStyles.heading.copyWith(fontSize: 50),
  //     text: title,
  //   );

  //   TextPainter tp = TextPainter(
  //     text: span,
  //     //textDirection: TextDirection.LTR,
  //     textAlign: TextAlign.center,
  //   );
  //   tp.text = TextSpan(
  //     text: title,
  //     style: const TextStyle(
  //       fontSize: 65.0,
  //       color: Colors.white,
  //     ),
  //   );

  //   PictureRecorder recorder = PictureRecorder();
  //   Canvas c = Canvas(recorder);
  //   Paint paint = Paint();
  //   paint.color = bgColor;
  //   c.drawCircle(const Offset(70.0, 80.0), 60, paint);
  //   tp.layout();
  //   tp.paint(c, const Offset(50.0, 40.0));

  //   /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

  //   Picture p = recorder.endRecording();
  //   ByteData? pngBytes =
  //       await (await p.toImage(tp.width.toInt() + 100, tp.height.toInt() + 100))
  //           .toByteData(format: ImageByteFormat.png);

  //   Uint8List data = Uint8List.view(pngBytes!.buffer);

  //   return BitmapDescriptor.fromBytes(data);
  // }

  static Future playSound() async {
    Soundpool pool = Soundpool.fromOptions(
        options: const SoundpoolOptions(streamType: StreamType.notification));
    int soundId = await rootBundle
        .load('assets/raw/alert.wav')
        .then((ByteData soundData) {
      print("here it is 1");
      return pool.load(soundData);
    });
//    await pool.play(soundId);
  }

  static String getMyDate(String date) {
    DateTime dt = DateFormat.yMMMd().parse(date);
    //final DateTime now = DateTime.now();
//    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat formatter = DateFormat.yMMMd();
    final String formatted = formatter.format(dt);
    return formatted;
  }

  String getTotalDeliveryPrice(List<OrderRequest> orderRequests) {
    double totalEarning = 0;
    for (OrderRequest orderRequest in orderRequests) {
      totalEarning =
          totalEarning + double.parse(orderRequest.deliveryPrice!.toString());
    }
    return totalEarning.toString();
  }

  //static Future<void> openMap(double latitude, double longitude, String dropoff) async {
  static Future<void> openMap(
      double latitude,
      double longitude,
      double pickupLat,
      double pickupLon,
      double dropoffLat,
      double dropoffLon) async {
    // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // Origin of route
    // Destination of route
    // Output format
    //String googleUrl = 'https://www.google.com/maps/dir/$latitude,$longitude/$dropoff_lat,$dropoff_lon';
    //String googleUrl = 'https://www.google.com/maps/dir/?saddr=$pickup_lat,$pickup_lon'+'&daddr=$dropoff_lat,$dropoff_lon';
    String googleUrl =
        'https://www.google.com/maps/dir/$pickupLat,$pickupLon/$dropoffLat,$dropoffLon/@$latitude,$longitude,13z'; //data=!3m1!4b1!4m10!4m9!1m3!2m2!1d74.3309!2d31.5378!1m3!2m2!1d74.3469!2d31.4627!3e0
    //print(googleUrl);
    //String googleUrl = 'https://www.google.com/maps/dir/'+ parameters;
    //String google_url ='https://www.google.com/maps/dir/?saddr='+pickup_lat.toString()+','+pickup_lon.toString()+'&daddr='+dropoff_lat.toString()+','+dropoff_lon.toString()+'&travelmode=driving&dir_action=navigate';

    print(googleUrl);
    if (await canLaunchUrlString(googleUrl)) {
      await launchUrlString(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  // static Future<void> navigate({required LatLng endPoint}) async {
  //   final link =
  //       'google.navigation:q=${endPoint.latitude},${endPoint.longitude}';
  //
  //
  //   final uri = Uri.parse(link);
  //   if (await canLaunchUrl(uri)) {
  //     launchUrl(uri, mode: LaunchMode.externalApplication);
  //   }
  // }

  static Future<void> navigate({required LatLng endPoint}) async {
    final link = Platform.isIOS
        ? 'https://maps.apple.com/?q=${endPoint.latitude},${endPoint.longitude}'
        : 'google.navigation:q=${endPoint.latitude},${endPoint.longitude}';
    log(link);
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    Fluttertoast.showToast(msg: 'No Application found');
  }

  static Future<bool?> agreeStatus(BuildContext context) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var status = sharedPreferences.getBool(kAgreed);
    if (status != null && status) return true;
    return await showDialog<bool>(
      context: context,
      builder: (_) => SimpleDialog(
        contentPadding: const EdgeInsets.all(20),
        title: const Text('Notice'),
        children: [
          const Text(
            'Mostly Rx app to access your location to better use our service',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await sharedPreferences.setBool('agreed', true);
                  },
                  child: const Text('Accept')),
              const SizedBox(width: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Hide',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
