import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/services/api.dart';

class UserLocation with ChangeNotifier {
  bool _init = false;
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  final StreamController<LocationData> _locationController =
      StreamController<LocationData>();
  Stream<LocationData> get locationData => _locationController.stream;

  Future<bool> startService({bool addListener = false}) async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    if (addListener) {
      location.onLocationChanged.listen((event) async {
        await updateLocation(event);
      });
      location.changeSettings(interval: 300000, distanceFilter: 300);
    }
    notifyListeners();
    return true;
  }

  Future<void> updateLocation(LocationData locationData) async {
    if (!_init) {
      _init = true;

      if (locationData.latitude != null && locationData.longitude != null) {
        try {
          await Api.updateLocation({
            'id': Constants.loggedInUser!.id!.toString(),
            'latitude': locationData.longitude.toString(),
            'longitude': locationData.latitude.toString()
          });
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error in updating location');
        }
      } else {
        Fluttertoast.showToast(msg: "Warning : can't get your location");
      }
    }
  }
}
