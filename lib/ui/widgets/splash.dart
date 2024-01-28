import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/display.dart';
import 'package:mostlyrx/ui/widgets/app_wrapper.dart';
import 'package:mostlyrx/ui/widgets/intro.dart';
import 'package:open_store/open_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_version_checker/store_version_checker.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  Widget build(BuildContext context) {
    DisplayDimension().init(context);
    Utils().init(context);
    return splash(context);
  }

  Widget splash(BuildContext context) {
    checkVersion();
    return Container(
      height: DisplayDimension().screenHeight,
      width: DisplayDimension().screenWidth,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          appIconBig(),
          const SizedBox(height: 30),
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(
              AppColors.primaryColor,
            ),
          )
        ],
      ),
    );
  }

  appIconBig() {
    return Container(
        width: DisplayDimension().screenWidth * 0.7,
        margin: const EdgeInsets.all(90),
        child: Image.asset('assets/images/app_logo.png'));
  }

  void checkSession(context) async {

    AuthenticationService authService = Provider.of(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    if (username != null && username.isNotEmpty) {
      String password = prefs.getString('password')!;
      var isLogin = await authService.login(username, password);
      if ((isLogin) && (Constants.loggedInUser != null)) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const AppWrapperWidget()),
            ModalRoute.withName('/home'));
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const IntroWidget()),
          ModalRoute.withName('/intro'),
        );
      }
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const IntroWidget()),
          ModalRoute.withName('/intro'),
        );
      });
    }
  }

  final _checker = StoreVersionChecker();

  checkVersion() async {
    _checker.checkUpdate().then((value) {
      print(value.canUpdate); //return true if update is available
      print(value.currentVersion); //return current app version
      print(value.newVersion); //return the new app version
      print(value.appURL); //return the app url
      print(value.errorMessage); //return error message if found else it will return null
      if(value.canUpdate)
      {
        _showVersionDialog(context,value.currentVersion,value.newVersion.toString());
      }else{
        checkStatus();
      }
    }).onError((error, stackTrace) {
      checkStatus();

    });
  }

  _showVersionDialog(context,String from,String to) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available, Please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () {
                OpenStore.instance.open(
                appStoreId: '1577354696', // AppStore id of your app for iOS
                androidAppBundleId: 'com.logixcess.mostlyrx', // Android app bundle package name
              );
              Navigator.pop(context);
              checkStatus();
              },
            ),
            TextButton(
              child: Text(btnLabelCancel),
              onPressed: () {
                checkStatus();
              },
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () {
                OpenStore.instance.open(
                appStoreId: '1577354696', // AppStore id of your app for iOS
                androidAppBundleId: 'com.logixcess.mostlyrx', // Android app bundle package name
              );
              Navigator.pop(context);
              checkStatus();
              },
            ),
            TextButton(
              child: Text(btnLabelCancel),
              onPressed: () {
                checkStatus();
              },
            ),
          ],
        );
      },
    );
  }

  checkStatus(){
    checkSession(context);
  }
}
