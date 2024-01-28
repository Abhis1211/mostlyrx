import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostlyrx/core/apimodels/order_response.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/services/api.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/core/services/location_service.dart';
import 'package:mostlyrx/core/viewmodels/views/orders_view_model.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:mostlyrx/ui/widgets/profile_editor.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool asked = false;
var orderStatus = ValueNotifier(false);

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  bool _isLoading = false;
  SharedPreferences? sharedPreferences;
  Timer? timer;
  String? assignedTime;
  List<Order> orders = [];
  int timeLeft = 0;
  static const _requestTime = 60;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initData();
    orderStatus.addListener(() {
      if (!mounted) return;
      initData();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (timer == null) return;
    if (state == AppLifecycleState.resumed && (!timer!.isActive)) {
      initData();
    }
  }

  Future initData() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    if (!Constants.loggedInUser!.isApproved) return;
    setState(() {
      _isLoading = true;
    });
    try {
      orders = await OrdersViewModel.getLocalOrders();

      if (orders.isNotEmpty) {
        assignedTime = sharedPreferences!.getString(kAssignedTime);
        if (assignedTime != null) {
          var seconds = DateTime.now()
              .difference(
                  DateTime.fromMillisecondsSinceEpoch(int.parse(assignedTime!)))
              .inSeconds;

          timeLeft = _requestTime - seconds;
        } else {
          assignedTime = DateTime.now().millisecondsSinceEpoch.toString();
          sharedPreferences?.setString(kAssignedTime, assignedTime!);
          timeLeft = _requestTime;
        }
        countDownTimer();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void countDownTimer() {
    if (timeLeft <= 0) {
      cancelCountDown();
      return;
    }
    if (timer != null && timer!.isActive) timer!.cancel();
    if ((assignedTime?.isNotEmpty ?? true) && orders.isNotEmpty) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          --timeLeft;
          if (timeLeft <= 0) {
            cancelCountDown();
          }
        });
      });
    }
  }

  void cancelCountDown() async {
    if (timer != null && timer!.isActive) timer!.cancel();
    sharedPreferences!.setStringList(kOrders, []);
    sharedPreferences!.remove(kAssignedTime);
    orderStatus.value = !orderStatus.value;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
      orders.clear();
      timeLeft = _requestTime;
    });
  }

  @override
  void dispose() {
    if (mounted && timer != null && timer!.isActive) timer!.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (context, data, _) {
        if (data == null && Constants.loggedInUser != null) {
          data = Constants.loggedInUser!;
        }
        if (data == null) {
          return const Center(child: Text('Not Signed In...'));
        }
        if (_isLoading) return const Center(child: CircularProgressIndicator());
        if (!data.isApproved) {
          return ListTile(
            tileColor: Colors.red,
            title: Text(
                data.documentsProvided
                    ? 'Documents is been processed'
                    : 'Account not Active',
                style: const TextStyle(color: Colors.white)),
            trailing: TextButton(
              onPressed: () async {
                if (data!.documentsProvided) {
                  sharedPreferences ??= await SharedPreferences.getInstance();
                  var lastcheck = sharedPreferences!.getInt(kLastCheck);
                  if (lastcheck != null) {
                    var saved = DateTime.fromMillisecondsSinceEpoch(lastcheck);
                    if (DateTime.now().difference(saved).inSeconds < 60) {
                      Fluttertoast.showToast(
                          msg: 'Please wait a moment to check again');
                      return;
                    }
                  }

                  var status = await Api().documnetState();
                  if (status != null) {
                    var verified = status['verified'];
                    if (verified != null && verified == 1) {
                      relogin();
                    } else {
                      await sharedPreferences!.setInt(
                          kLastCheck, DateTime.now().millisecondsSinceEpoch);
                      Fluttertoast.showToast(
                          msg: 'Not Verified please check again in 1 minute');
                    }
                  }
                } else {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => const ProfileEditor()));
                }
              },
              child: Text(
                data.documentsProvided ? 'Refresh' : 'Activate',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          );
        }

        setUpLocationCallback(context);

        if (orders.isEmpty) {
          return const Center(
              child: Text(
            'No Activities to Show',
            style: TextStyle(color: Color(0xFF129D4C), fontSize: 17),
          ));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _OrderCard(orders[index], timeLeft, () async {
              cancelCountDown();
              setState(() {
                _isLoading = true;
              });
              await Api().updateOrderStatus({
                'order_id': orders[index].id.toString(),
                'order_status': 'assigned',
                'fk_assigned_driver_id': data!.id!.toString()
              }).then((value) {
                ///goto order accept screen
                if (value != null) {
                  Navigator.of(Constants.appNavigationKey.currentState!.context)
                      .pushNamed('/order_status_screen', arguments: [
                    "Order Accepted!",
                    "order_accept.png",
                    0
                  ]);
                } else {
                  Navigator.of(Constants.appNavigationKey.currentState!.context)
                      .pushNamed('/order_status_screen', arguments: [
                    "Order Assigned already",
                    "assigned.png",
                    1
                  ]);
                }
              });
              setState(() {
                _isLoading = false;
              });
            });
          },
        );
      },
    );
  }

  relogin() async {
    AuthenticationService service = Provider.of(context, listen: false);
    await service.login(sharedPreferences!.getString(kUserName)!,
        sharedPreferences!.getString(kPassword)!);
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
          arguments: 0);
    }
  }

  setUpLocationCallback(context) async {
    if (asked) return;
    asked = true;
    final locationService = Provider.of<UserLocation>(context, listen: false);
    await locationService.startService();
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final int timeLeft;
  final VoidCallback model;
  const _OrderCard(this.order, this.timeLeft, this.model, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 3.0,
              color: AppColors.greenLight.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0.0, 4.0),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '\$${order.totalPrice} ',
                      style: poppinsMedium.copyWith(
                        fontSize: 20,
                        color: AppColors.blueColor,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Stops: ',
                          style: poppinsMedium.copyWith(
                            fontSize: 20,
                            color: AppColors.greyText,
                          ),
                        ),
                        TextSpan(
                          text: '${order.totalStops}',
                          style: poppinsMedium.copyWith(
                            fontSize: 20,
                            color: AppColors.blueColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '00:${timeLeft < 10 ? "0$timeLeft" : timeLeft}',
                      style: poppinsMedium.copyWith(
                        fontSize: 20,
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                ],
              ),

              ///
              SizedBox(height: height * 0.012),
              Text((order.pharmacy?.name ?? '').toUpperCase(),
                  style: poppinsBold.copyWith(
                    fontSize: 24,
                    color: AppColors.primaryOneColor,
                  ),
              ),

              ///
              const SizedBox(height: 8),
              Text('Pickup Address:',
                  style: poppinsSemiBold.copyWith(
                    fontSize: 15,
                    color: AppColors.greenLight,
                  ),
              ),

              ///
              SizedBox(height: height * 0.013),
              Text(order.pharmacy?.address ?? 'order.pharmacy?.address',
                style: poppinsRegular.copyWith(
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
              ),

              ///
              SizedBox(height: height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context)
                          .pushNamed('/order_details', arguments: order);
                    },
                    child: Container(
                      width: height * 0.1,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.primaryOneColor,
                      ),
                      child: Center(child: Text('View',
                        style: poppinsSemiBold.copyWith(
                          fontSize: 12,
                          color: AppColors.whiteColor,
                        ),
                      ),),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: model,
                    child: Container(
                      width: height * 0.1,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: AppColors.whiteColor,
                        border: Border.all(
                          color: AppColors.primaryOneColor,
                          width: 1.1,
                        ),
                      ),
                      child: Center(child: Text('Accept',
                        style: poppinsSemiBold.copyWith(
                          fontSize: 12,
                          color: AppColors.primaryOneColor,
                        ),
                      ),),
                    ),
                  ),

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      DateFormat.yMMMd().format(
                        order.createdAt ?? DateTime.now(),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ],
    );
  }
}
