import 'package:flutter/cupertino.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/models/user.dart';

class Constants {
  static GlobalKey<NavigatorState> appNavigationKey =
      GlobalKey<NavigatorState>();
  static User? loggedInUser;
  static Order? currentOrder;
  static OrderRequest? selectedOrderRequest;
}

//*shared pref keys
const kOrders = 'orders';
const kAssignedTime = 'assignedtime';
const kAgreed = 'agreed';
const kUserName = 'username';
const kPassword = 'password';
const kVerificationID = 'localverificationId';
const kLastCheck = 'lastcheck';
