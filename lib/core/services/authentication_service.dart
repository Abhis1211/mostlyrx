import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:mostlyrx/core/apimodels/driver_login.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/apimodels/single_order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/constants/utils.dart';

import 'package:mostlyrx/core/models/notifications_model.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/services/api.dart';
import 'package:mostlyrx/globals.dart';
import 'package:mostlyrx/ui/view/home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'notification_service.dart';

Future<void> saveOrderFromNotification(
    Map<String, dynamic>? data, bool fromClick) async {
  log('$data');

  AssetsAudioPlayer.newPlayer().open(
    Audio('assets/raw/notification.mp3'),
    autoStart: true,
    showNotification: true,
  );
  AssetsAudioPlayer.newPlayer().play();
  
  // Soundpool pool = Soundpool.fromOptions(
  //     options: const SoundpoolOptions(
  //         streamType: StreamType.notification,
  //         androidOptions: SoundpoolOptionsAndroid.kDefault));
  // int soundId = await rootBundle
  //     .load('assets/raw/notification.mp3')
  //     .then((ByteData soundData) {
  //   return pool.load(soundData);
  // });
  // await pool.play(soundId);
  if (data != null && data.containsKey('order_id')) {
    var pref = await SharedPreferences.getInstance();
    var orders = pref.getStringList(kOrders) ?? [];
    var orderId = data['order_id'].toString();
    if (!orders.contains(orderId)) {
      orderStatus.value = !orderStatus.value;
      orders.add(orderId);
      await pref.setStringList(kOrders, orders);
      await pref.setString(
          kAssignedTime, DateTime.now().millisecondsSinceEpoch.toString());
      Soundpool pool = Soundpool.fromOptions(
          options: const SoundpoolOptions(streamType: StreamType.notification));
      int soundId = await rootBundle
          .load('assets/raw/alert.wav')
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
      print("here it is");
      if (fromClick) await pool.play(soundId);
    }
  }
}

class AuthenticationService {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  final Api _api;
  static String? registredInfo;
  AuthenticationService({required Api api}) : _api = api;
  final StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;
  final StreamController<NotificationModel?> _notificationController =
      StreamController<NotificationModel?>();

  Stream<NotificationModel?> get notification => _notificationController.stream;

  Future<bool> login(String email, String password) async {
    var fetchedUser =
        await _api.loginUser({'email': email, 'password': password});
    if (fetchedUser != null) {
      DriverLoginResponse? driver = driverLoginResponseFromJson(fetchedUser);
      var hasUser = driver != null;
      if (hasUser) {
        Constants.loggedInUser = driver.response!;
        if (_userController.isClosed) {
          _userController.sink.add(driver.response!);
        } else {
          _userController.add(driver.response!);
        }
        userID = Constants.loggedInUser!.id.toString();
        saveSession(email, password, Constants.loggedInUser!.isApproved);
      }
      return hasUser;
    }
    return false;
  }

  Future<bool> saveSession(
      String username, String password, bool isApproved) async {
    log('saveSession');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kUserName, username);
    await prefs.setString(kPassword, password);
    setupOneSignal();
    return true;
  }

  Future<void> register() async {
    try {
      if (registredInfo != null) {
        var dio = Dio()
          ..interceptors.add(InterceptorsWrapper(
            onError: (e, handler) {
              Logger().e('PROBLEM :)');
              handler.next(e);
            },
          ));
        var data = jsonDecode(registredInfo!);
        var response = await dio.post('${Api.endpoint}/register', data: {
          'name': data['name'],
          'contact': "+1${data['contact']}",
          'email': data['email'],
          'password': data['password'],
          'latitude': data['latitude'].toString(),
          'longitude': data['longitude'].toString(),
          'permanent_address': data['address']
        });

        if (response.statusCode == 200 && response.data['code'] == 200) {
          DriverLoginResponse? driver =
              DriverLoginResponse.fromJson(response.data);

          if (data['token'].isNotEmpty) {
            await updateToken(driver.response!.id.toString(), data['token']);
          }
          Constants.loggedInUser = driver.response!;
          _userController.add(driver.response!);
          saveSession(data['email'], data['password'],
              Constants.loggedInUser!.isApproved);
          registredInfo = null;
          Navigator.of(Constants.appNavigationKey.currentState!.context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        } else {
          Utils.showMessageDialoge(response.data['message']);
        }
      }
    } on DioError {
      Utils.showMessageDialoge('email already exist');
    }
  }

  Future<bool> updateToken(String id, String token) async {
    var fetchedUser = await _api.updateToken({
      'id': id,
      'device_token': token,
    });
    return fetchedUser != null;
  }

  Future<bool> updateProfile(String name, String email, String password,
      String contact, String address) async {
    var fetchedUser = await _api.updateDriverProfile({
      'name': name,
      'contact': contact,
      'email': email,
      'password': password,
      'permanent_address': address
    });
    if (fetchedUser != null) {
      DriverLoginResponse? driver = driverLoginResponseFromJson(fetchedUser);
      var hasUser = driver != null;
      if (hasUser) {
        _userController.add(driver.response!);
      }
      return hasUser;
    }
    return false;
  }

  Future<bool> updateAvailability(String id, String available) async {
    var fetchedUser = await _api
        .updateDriverAvailability({'driver_id': id, 'status': available});
    if (fetchedUser != null) {}
    //print(fetchedUser.toString());
    return fetchedUser != null;
  }

  Future<bool> updateLocation(String id, String lat, String lng) async {
    var fetchedUser =
        await Api.updateLocation({'id': id, 'latitude': lat, 'longitude': lng});
    return fetchedUser != null;
  }

  Future<Order?> getOrderById(String id) async {
    var fetchedData = await _api.getOrderById(id);
    if (fetchedData != null) {
      SingleOrderResponse? order = singleOrderResponseFromJson(fetchedData);
      var hasData = order != null;
      if (hasData) {
        return order.order;
      }
      return null;
    }
    return null;
  }

  Future<void> sendSMS(String phoneNumber, BuildContext context,
      ValueSetter<bool> smsSend) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1$phoneNumber',
        verificationCompleted: (complted) {},
        verificationFailed: (faild) {
          Utils.showMessageDialoge('Send sms faild with ${faild.message}');
          Navigator.pop(context);
        },
        codeSent: (code, number) {
          SharedPreferences.getInstance().then((value) async {
            await value.setString(kVerificationID, code);
          });
          smsSend(true);
        },
        codeAutoRetrievalTimeout: (repeat) {});
  }

  Future<void> verfiePhoneNumber(String smsCode) async {
    var pref = await SharedPreferences.getInstance();
    var id = pref.getString(kVerificationID);
    if (id == null) {
      Fluttertoast.showToast(msg: 'Please wait for the sms');
      return;
    }
    await FirebaseAuth.instance
        .signInWithCredential(
            PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode))
        .then((value) async {
      SharedPreferences.getInstance().then((value) async {
        await value.remove(kVerificationID);
      });
      await register();
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: '$error');
    });
  }

  Future<void> setupOneSignal() async {
    log('===setup OneSignal===');
    var deviceState = (await OneSignal.shared.getDeviceState())!;
    OneSignal.shared.disablePush(false);
    unawaited(updateToken(
        Constants.loggedInUser?.id.toString() ?? '', deviceState.userId ?? ''));
    if (!deviceState.subscribed && Platform.isIOS) {
      await OneSignal.shared.promptUserForPushNotificationPermission();
    }
    OneSignal.shared.setSubscriptionObserver((changes) async {
      if (changes.from.isSubscribed && !changes.to.isSubscribed) {
        await OneSignal.shared.promptUserForPushNotificationPermission();
      }
    });
    Constants.loggedInUser?.token = deviceState.userId;
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) async {
      print("its here:${event.notification.additionalData}");
      OneSignal.shared.clearOneSignalNotifications();
      saveOrderFromNotification(event.notification.additionalData, true);
      event.complete(event.notification);
    });
    OneSignal.shared.setNotificationOpenedHandler((result) async {
      print("its here now");
      await OneSignal.shared.clearOneSignalNotifications();
      await saveOrderFromNotification(
          result.notification.additionalData, false);
    });
  }

  Future<void> deleteUser(BuildContext context, bool mounted) async {
    if (Constants.loggedInUser != null) {
      final user = Constants.loggedInUser!;
      final deleted = await _api.deleteAccount(user.id, user.email);
      if (deleted) {
//        OneSignal.shared.disablePush(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Constants.loggedInUser = null;
        Constants.currentOrder = null;
        Constants.selectedOrderRequest = null;
        NotificationService.instance.showDeleteNotification();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/intro', (Route<dynamic> route) => false);
        }
        return;
      }
      Fluttertoast.showToast(msg: 'Error!! Please try again');
    }
  }
}
