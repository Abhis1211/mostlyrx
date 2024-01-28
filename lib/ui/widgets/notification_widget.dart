// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/utils.dart';
import 'package:mostlyrx/core/models/notifications_model.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/styles.dart';

bool _requestProcessing = false;

class NewJobNotificationWidget extends StatefulWidget {
  final NotificationModel _model;
  final Function onReject, onAccept, onTimeout;
  const NewJobNotificationWidget(
      this._model, this.onAccept, this.onReject, this.onTimeout,
      {Key? key})
      : super(key: key);

  @override
  State<NewJobNotificationWidget> createState() =>
      _NewJobNotificationWidgetState();
}

class _NewJobNotificationWidgetState extends State<NewJobNotificationWidget> {
  Timer? mTimer;
  int secondsRemaining = 30;

  @override
  Widget build(BuildContext context) {
    return notification(context);
  }

  @override
  void initState() {
    _requestProcessing = false;
    secondsRemaining = 30;
    if (widget._model.order != null && mTimer == null) {
      mTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        secondsRemaining = secondsRemaining > 0 ? secondsRemaining - 1 : 0;
        if (widget._model.order != null && secondsRemaining < 1) {
          mTimer = null;
          timer.cancel();
          widget.onTimeout();
        }
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    mTimer?.cancel();
    super.dispose();
  }

  notification(BuildContext context) {
    return widget._model.order == null
        ? Container()
        : Container(
            width: Utils.dimensions!.width,
            color: AppColors.primaryColor,
            child: Column(
              children: [
                Container(
                  width: Utils.dimensions!.width,
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'New Order Request',
                      style: AppTextStyles.normal.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Utils.dimensions!.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '00:$secondsRemaining',
                                style: AppTextStyles.heading.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 18),
                              ),
                              Text(
                                'Countdown',
                                style: AppTextStyles.subtitle.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Deliveries',
                              style: AppTextStyles.normal
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              widget._model.order!.orderRequests!.length
                                  .toString(),
                              style: AppTextStyles.heading.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          widget.onReject();
                        },
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'REJECT',
                            style: AppTextStyles.normal
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    _requestProcessing
                        ? const SizedBox(
                            height: 30,
                            child: Center(child: CircularProgressIndicator()))
                        : ButtonTheme(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                _requestProcessing = true;
                                widget.onAccept();
                              },
                              color: AppColors.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'ACCEPT',
                                  style: AppTextStyles.normal
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                  ],
                )
              ],
            ),
          );
  }
}
