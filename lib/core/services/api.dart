import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mostlyrx/core/apimodels/driver_login.dart';

import 'package:mostlyrx/core/constants/app_contstants.dart';

import 'package:mostlyrx/core/constants/utils.dart';
import 'package:retry/retry.dart';

class Api {
  static const endpoint = 'https://www.mostlyrx.com/delivery/api';
  var client = http.Client();
  Future<dynamic> loginUser(Map<dynamic, String> body) async {
    var response =
        await retry(() => client.post(Uri.parse('$endpoint/login'), body: body),
            retryIf: (e) => e is SocketException || e is TimeoutException,
            maxAttempts: 5,
            onRetry: (e) {
              Utils.showToast('Retry Connection', Colors.white);
            });
     print("response:${'$endpoint/login'} :${response.body}");
    return afterValidation(response);
  }

  Future<dynamic> changePassword(Map<String, dynamic> body) async {
    var response =
        await client.post(Uri.parse('$endpoint/changePassword'), body: body);
    return afterValidation(response);
  }

  Future<dynamic> registerUser(Map<dynamic, String> body) async {
    // Get user profile for id
    late http.Response response;
    try {
      response = await client.post(Uri.parse('$endpoint/register'), body: body);
    } catch (e) {
      Logger().e(e);
    }

    return afterValidation(response);
  }

  Future<dynamic> updateToken(Map<dynamic, String> body) async {
    // Get user profile for id
    var response = await Dio().post('$endpoint/update_token', data: body);

    // Convert and return
    return response.data;
  }

  static Future<dynamic> updateLocation(Map<String, dynamic> body) async {
    // Get user profile for id
    var response = await http.Client()
        .post(Uri.parse('$endpoint/update_location'), body: body);
    // Convert and return
    return response.body;
  }

  Future<dynamic> logout(int userId) async {
    // Get user posts for id
    var response = await client.get(Uri.parse('$endpoint/logout/$userId'));

    return response.body;
  }

  Future<dynamic> updateDriverProfile(Map<dynamic, String> body) async {
    print("updateProfile:$body");
    var response =
        await client.post(Uri.parse('$endpoint/updateProfile'), body: body);
    return response.body;
  }

  Future<dynamic> updateDriverAvailability(Map<dynamic, String> body) async {
    print("update_user_status:$body");
    // Get user profile for id
    var response = await client.post(Uri.parse('$endpoint/update_user_status'),
        body: body);
    // Convert and return
    return response.body;
  }

  Future<dynamic> getOrderById(String id) async {
    print("getOrder:$id");
    // Get user profile for id
    var response = await client.get(Uri.parse('$endpoint/getOrder/$id'));
    debugPrint("${'$endpoint/getOrder/$id'}:response.body local:${response.body}",wrapWidth: 1024);
    // Convert and return
    return afterValidation(response);
  }

  Future<dynamic> getPendingOrders(String id) async {
    print("getPendingOrder:$id");
    // Get user profile for id
    var response = await client.get(Uri.parse('$endpoint/getPendingOrder/$id'));
    // Convert and return
    return afterValidation(response, showToast: false);
  }

  Future<dynamic> getOrders(String id) async {
    // Get user profile for id
    print("get_my_orders:$id");
    var response =
        await http.Client().get(Uri.parse('$endpoint/get_my_orders/$id'));
    //var response = await client.get('$endpoint/get_my_orders/$id');
    // Convert and return

    return afterValidation(response);
  }

  Future<dynamic> getEarning(String id) async {
    // Get user profile for id
    // Logger().v('$endpoint/getEarning/$id');
    var response = await client.get(Uri.parse('$endpoint/getEarning/$id'));
    debugPrint("${Uri.parse('$endpoint/getEarning/$id')}:response:${response.body}",wrapWidth: 1024);
    return afterValidation(response);
  }

  Future<dynamic> getNotificationCount(String id) async {
    // Get user profile for id
    // Logger().v('$endpoint/getEarning/$id');
    var response = await client.get(Uri.parse('$endpoint/get_notifications_count/$id'));
    debugPrint("${Uri.parse('$endpoint/get_notifications_count/$id')}:response:${response.body}",wrapWidth: 1024);
    return afterValidation(response);
  }
  Future<dynamic> getNotifications(String id) async {
    // Get user profile for id
    // Logger().v('$endpoint/getEarning/$id');
    var response = await client.get(Uri.parse('$endpoint/get_notifications/$id'));
    debugPrint("${Uri.parse('$endpoint/get_notifications/$id')}:response:${response.body}",wrapWidth: 1024);
    return afterValidation(response);
  }

  Future<dynamic> updateOrderStatus(Map<dynamic, String> body) async {
    print("update_order_status:$body");
    // Get user profile for id
    var response = await client.post(Uri.parse('$endpoint/update_order_status'),
        body: body);
    // Convert and return
    print("response:${response.body}");
    return afterValidation(response);
  }

  Future<dynamic> rejectOrderRequest(Map<dynamic, String> body) async {
    print("rejectRequest:$body");
    // Get user profile for id\
    // print('-------------------------------');
    // print('123-------' + body.toString());
    // print('-------------------------------');
    var response =
        await client.post(Uri.parse('$endpoint/rejectRequestDriver'), body: body);
    print("${Uri.parse('$endpoint/rejectRequestDriver')}  :response:${response.body}");

    // Convert and return
    // print('-------------------------------');
    // print('---' + response.body);
    // print('-------------------------------');
    return afterValidation(response);
  }

  Future<dynamic> updateOrderRequestStatus(Map<dynamic, String> body) async {
    print("changeDeliveryStatus:$body");
    // Get user profile for id
    var response = await client
        .post(Uri.parse('$endpoint/changeDeliveryStatus'), body: body);
    // Convert and return
    // print(body.toString());
    // print(response.body);
    return afterValidation(response);
  }

  Future<dynamic> addSignature(String orderId, String filePath) async {

    FormData formData = FormData.fromMap({
      'order_id': orderId,
      'customer_signature': await MultipartFile.fromFile(filePath)
    });
    print("add_signature:$formData");
    final response = await Dio().post('$endpoint/add_signature', data: formData,
        onReceiveProgress: (int sent, int total) {
      //print(progress);
    });
    if (afterValidationDynamic(response.data)) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<dynamic> getRoute(String id) async {
    print("getRouteOfOrder:$id");
    // Get user profile for id
//  String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${body['pickup']}${body.containsKey('dropoff_points') ? body['dropoff_points'] : ''} &destination=${body['destination']}&key=${body['api_key']}';
    var response = await client.get(Uri.parse('$endpoint/getRouteOfOrder/$id'));
    // Convert and return
    //print(response.body);
    return afterValidation(response);
  }

  Future<dynamic> getSingleOrderRequestRoute(Map<dynamic, String> body) async {
    print("getSingleRoute:$body");
    var response =
        await client.post(Uri.parse('$endpoint/getSingleRoute'), body: body);
    return afterValidation(response);
  }

  afterValidation(http.Response response, {bool showToast = true}) {
    if (response.statusCode == 200) {
      if (handleError(response.body, showToast: showToast)) {
        return response.body;
      }
    }
    return null;
  }

  bool handleError(String body, {bool showToast = true}) {
    APITest apiTest = APITest.fromJson(json.decode(body));
    //print(body);
    switch (apiTest.status?.toLowerCase()) {
      case 'success':
        return true;
      case 'failed':
        if (showToast) Utils.showToast(apiTest.message!, Colors.red);
        return false;
      default:
        return false;
    }
  }

  afterValidationDynamic(dynamic response) {
    if (response['status'] != 'success') {
      Utils.showToast(response['message'], Colors.red);
      return false;
    }
    return response['status'] == 'success';
  }

  Future<bool> uploadFile(
      {required List<MultipartFile> proofs,
      required List<MultipartFile> licenses}) async {
    try {
      var dio = Dio()
        ..interceptors.add(InterceptorsWrapper(
          onError: (e, handler) {
            handler.next(e);
          },
        ));
      var response = await dio.post('$endpoint/users/verify',
          data: FormData.fromMap({
            'id': Constants.loggedInUser?.id,
            'proof[]': proofs,
            'license[]': licenses
          }));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Uploaded!!');
        return true;
      }
    } on DioError {
      Fluttertoast.showToast(msg: 'Problem in Uploading please try again');
      return false;
    }
    return false;
  }
  Future<bool> uploadProfile(
      {
        required List<MultipartFile> licenses}) async {
    try {
      var dio = Dio()
        ..interceptors.add(InterceptorsWrapper(
          onError: (e, handler) {
            handler.next(e);
          },
        ));
      print('its here:${'$endpoint/api/updateProfilePicture'}');
      var response = await dio.post('$endpoint/updateProfilePicture',
          data: FormData.fromMap({
            'id': Constants.loggedInUser?.id,
            'image': licenses.first,
          }));
      if (response.statusCode == 200) {
        Constants.loggedInUser!.imageurl = response.data['imageurl'];
        //Fluttertoast.showToast(msg: 'Uploaded!!');
        return true;
      }
    } on DioError {
      print(DioError);
      Fluttertoast.showToast(msg: 'Problem in Uploading please try again');
      return false;
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> deleteAccount(int? userId, String? email) async {
    try {
      final response = await client
          .get(Uri.parse('$endpoint/user/delete?id=$userId&email=$email'));
      Logger().v(response.body);
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error in deleting account please try again');
      return false;
    }
  }

  Future documnetState() async {
    var dio = Dio()
      ..interceptors.add(InterceptorsWrapper(
        onError: (e, handler) {
          handler.next(e);
        },
      ));
    var response = await dio.get('$endpoint/users/documents',
        queryParameters: {'user': Constants.loggedInUser?.id});
    if (response.statusCode == 200) {
      return response.data;
    }
  }
}

class APITest {
  String? status;
  int? code;
  String? message;

  APITest({
    this.status,
    this.code,
    this.message,
  });

  factory APITest.fromJson(Map<String, dynamic> json) => APITest(
        status: json['status'],
        code: json['code'],
        message: json['message'],
      );
}
