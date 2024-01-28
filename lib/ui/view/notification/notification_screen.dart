import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mostlyrx/core/apimodels/notification_model.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/models/notify_model.dart';
import 'package:mostlyrx/core/viewmodels/notification_view_model.dart';
import 'package:mostlyrx/globals.dart';
import 'package:mostlyrx/ui/constants/icons.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:mostlyrx/ui/view/base_widget.dart';
import 'package:mostlyrx/ui/view/notification/components/notification_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationData> notificationList=[];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (){
        Navigator.of(Constants
            .appNavigationKey.currentState!.context)
            .pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false,
            arguments: 0);
        return Future.value(true);
      },
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                  bottom: 0,
                  child: Image.asset('assets/vectors/Vector 1.png',
                      width: size.width, fit: BoxFit.fitWidth)),
              Positioned(
                bottom: 0,
                child: Image.asset('assets/vectors/Vector 2.png'),
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
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// appbar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(Constants
                                  .appNavigationKey.currentState!.context)
                                  .pushNamedAndRemoveUntil(
                                  '/home', (Route<dynamic> route) => false,
                                  arguments: 0);
//                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 36,
                              width: 36,
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
                                  color: AppColors.greenDarkColor, size: 18),
                            ),
                          ),
                          Text(
                            'Notifications',
                            style: poppinsSemiBold.copyWith(
                              fontSize: 18,
                              color: AppColors.primaryOneColor,
                            ),
                          ),
                          SvgPicture.asset(AppIcons.tick),
                        ],
                      ),
                    ),

                    /// body
              BaseWidget<NotificationViewModel>(
                        model:
                        NotificationViewModel(
                            orderService:
                            Provider.of(
                                context)),
                        onModelReady: (model) async {

                          var localModel = await model
                              .getNotifications(
                              userID);
                          setState(() {
                            if (localModel != null) {
                              notificationList = localModel;
                            }
                            ;
                          });
                          return localModel;
                        },
                      builder: (context, model,child) {
                        return  model.busy
                            ? Expanded(
                              child: const Center(
                              child:
                              CircularProgressIndicator()),
                            ):
                            Expanded(child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                               // reverse:true,
                                itemCount: model.notifcations.length,
                                itemBuilder:(_,index)=>NotificationWidget(
                              iconPath: AppIcons.reward,
                              heading: model.notifcations[index].title.toString(),
                              timeText: timeago.format((model.notifcations[index].createdAt??DateTime.now())).toString(),
                              description: model.notifcations[index].content.toString(),
                            )))
                         /*Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Text(
                                'Today',
                                style: poppinsBold.copyWith(
                                  fontSize: 16,
                                  color: AppColors.greyScale500,
                                ),
                              ),
                              for (int i = 0; i < todayItems.length; i++)
                                NotificationWidget(
                                  iconPath: todayItems[i].iconPath,
                                  heading: todayItems[i].heading,
                                  timeText: todayItems[i].time,
                                  description: todayItems[i].description,
                                ),
                              const SizedBox(height: 24),

                              Text(
                                'This Week',
                                style: poppinsBold.copyWith(
                                  fontSize: 16,
                                  color: AppColors.greyScale500,
                                ),
                              ),
                              for (int i = 0; i < weekItems.length; i++)
                                NotificationWidget(
                                  iconPath: weekItems[i].iconPath,
                                  heading: weekItems[i].heading,
                                  timeText: weekItems[i].time,
                                  description: weekItems[i].description,
                                ),
                            ],
                          ),
                        )*/;
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
