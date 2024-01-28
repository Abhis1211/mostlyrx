// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/models/notifications_model.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/core/viewmodels/views/notification_count_model.dart';
import 'package:mostlyrx/globals.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/icons.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:mostlyrx/ui/view/base_widget.dart';

import 'package:mostlyrx/ui/view/earnings_view.dart';
import 'package:mostlyrx/ui/view/notification/notification_screen.dart';
import 'package:mostlyrx/ui/view/orders_view.dart';

import 'package:mostlyrx/ui/view/home.dart';

import 'package:mostlyrx/ui/view/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mostlyrx/core/constants/utils.dart';

var backgroundNotificaitonState = ValueNotifier(false);

class AppWrapperWidget extends StatefulWidget {
  final int? index;
  const AppWrapperWidget({Key? key, this.index}) : super(key: key);
  @override
  State<AppWrapperWidget> createState() => _AppWrapperWidgetState();
}

class _AppWrapperWidgetState extends State<AppWrapperWidget> {
  int _selectedTabIndex = 0;
  SharedPreferences? pref;

  final List<Widget> _pages = [
    const HomeView(),
    const OrdersView(),
    const EarningsView(),
    const ProfileWidget(),
  ];
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        backgroundNotificaitonState.value = value.getBool('bgl') ?? false;
        pref = value;
      });
    });
    if (widget.index != null) {
      _changeIndex(widget.index!);
    }
    super.initState();
  }

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  int notiCount = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<NotificationModel?>(builder:
        (BuildContext context, NotificationModel? value, Widget? child) {
      return Stack(
        children: [
          Scaffold(
            appBar: _selectedTabIndex == 2
                ? null
                : AppBar(
                    centerTitle: _selectedTabIndex == 3 ? true : false,
                    foregroundColor: Colors.transparent,
                    toolbarHeight: 70,
                    shadowColor: Colors.black.withOpacity(0.5),
                    toolbarOpacity: 0.0,
                    elevation: _selectedTabIndex == 3 ? 0 : 5,
                    automaticallyImplyLeading: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: _selectedTabIndex == 3
                          ? BorderRadius.circular(0)
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: _selectedTabIndex == 3
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Profile',
                                  style: appBarTitleStyle,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Image.asset('assets/images/app_logo.png',
                                    width: 90, height: 80),
                                SizedBox(width: size.height * 0.06),
                                _selectedTabIndex == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationScreen(),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0, right: 3),
                                              child: SvgPicture.asset(
                                                  AppIcons.bell,
                                                  height: 35),
                                            ),
                                             BaseWidget<NotificationCountViewModel>(
                                                model:
                                                    NotificationCountViewModel(
                                                        orderService:
                                                            Provider.of(
                                                                context)),
                                                onModelReady: (model) async {
                                                  var localModel = await model
                                                      .getNotificationCount(
                                                      userID);
                                                  setState(() {
                                                    if (localModel != null) {
                                                      notiCount = localModel;
                                                    }
                                                    ;
                                                  });
                                                  return localModel;
                                                },
                                                builder: (context, model,
                                                        child) =>
                                                    model.busy
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator())
                                                        : model.notiCount != null
                                                            ?
                                                    model.notiCount==0?Container():
                                                    Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  height: 16,
                                                                  width: 16,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: AppColors
                                                                        .redColor,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      model.notiCount.toString(),
                                                                      style: poppinsBold
                                                                          .copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        color: AppColors
                                                                            .whiteColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container()),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                    ),
                    // backgroundColor: _selectedTabIndex == 3 ? Colors.transparent : Colors.white,
                    backgroundColor: AppColors.whiteColor,
                  ),
            body: Stack(
              children: [
                Positioned(
                    bottom: 0,
                    child: Image.asset('assets/vectors/Vector 1.png',
                        width: size.width, fit: BoxFit.fitWidth)),
                Positioned(
                    bottom: size.height * .5,
                    child: Image.asset('assets/vectors/vector 3.png')),
                Positioned(
                  bottom: 0,
                  child: Image.asset('assets/vectors/Vector 2.png'),
                ),
                _pages[_selectedTabIndex]
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedTabIndex,
              type: BottomNavigationBarType.fixed,
              onTap: _changeIndex,
              backgroundColor: const Color(0xFF65C58D),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.6),
              selectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              items: [
                _bottomNavigationBarItemBuilder(
                    iconName: 'home', label: 'Home'),
                _bottomNavigationBarItemBuilder(
                    iconName: 'my_orders', label: 'My Orders'),
                _bottomNavigationBarItemBuilder(
                    iconName: 'my_earning', label: 'My Earning'),
                _bottomNavigationBarItemBuilder(
                    iconName: 'profile', label: 'Profile'),
              ],
            ),
          ),
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(top: kTextTabBarHeight - 17),
              child: Image.asset(
                'assets/vectors/Vector 4.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          _selectedTabIndex == 3
              ? Container()
              : _selectedTabIndex == 2
                  ? SizedBox()
                  : Positioned(
                      top: kToolbarHeight / 1.7,
                      right: 0,
                      child: getActiveSlider(),
                    ),
          _selectedTabIndex == 3
              ? Positioned(
                  top: kToolbarHeight / 1,
                  left: 24,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withOpacity(0.24),
                          blurRadius: 4,
                          offset: const Offset(0.0, 4.0),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.greenDarkColor, size: 20),
                  ),
                )
              : SizedBox(),
        ],
      );
    });
  }

  //*I hade to use image becuase there is no ICON
  BottomNavigationBarItem _bottomNavigationBarItemBuilder(
          {required String iconName, required String label}) =>
      BottomNavigationBarItem(
          icon: Image.asset('assets/icons/$iconName.png',
              color: Colors.white.withOpacity(0.5)),
          activeIcon:
              Image.asset('assets/icons/$iconName.png', color: Colors.white),
          label: label);

  getActiveSlider() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            var user = Constants.loggedInUser!;
            if (!user.isApproved) {
              Fluttertoast.showToast(
                  msg: 'You are not Approved yet', backgroundColor: Colors.red);
              return;
            }
            Fluttertoast.showToast(msg: 'Updating please wait');

            AuthenticationService authService =
                Provider.of<AuthenticationService>(context, listen: false);
            var resp = await authService.updateAvailability(
                Constants.loggedInUser!.id.toString(),
                user.status! == 'available' ? 'unavailable' : 'available');
            if (resp != null) {
              Constants.loggedInUser!.status =
                  (user.status! == 'available') ? 'unavailable' : 'available';
            }
            Fluttertoast.showToast(msg: 'Status Update!!');
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 75,
            alignment: Constants.loggedInUser!.status! == 'available' &&
                    Constants.loggedInUser!.isApproved
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.only(top: 13, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Constants.loggedInUser!.status! == 'available' &&
                        Constants.loggedInUser!.isApproved
                    ? const Color(0xFF43A047)
                    : Colors.red),
            child:
                const CircleAvatar(radius: 13, backgroundColor: Colors.white),
          ),
        ),
        const SizedBox(height: 3),
        DefaultTextStyle(
          style: const TextStyle(),
          child: Text(
            Constants.loggedInUser!.status! == 'available' &&
                    Constants.loggedInUser!.isApproved
                ? 'Active'
                : 'Offline',
            style: const TextStyle(color: Color(0xFF6A6A6A)),
          ),
        )
      ],
    );
  }
}
