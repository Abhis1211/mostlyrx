import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/icons.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:mostlyrx/ui/view/profile/components/profile_data_widget.dart';
import 'package:mostlyrx/ui/widgets/custom_alert_dialog.dart';
import 'package:mostlyrx/ui/widgets/profile_editor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer<User?>(
      builder: (context, data, _) {
        return data == null
            ? const Center(child: Text('nothing found'))
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      ///
                      SizedBox(height: height * 0.03),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.17),
                              blurRadius: 32,
                              offset: const Offset(0, 6.0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (_) => const ProfileEditor()))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: SizedBox(
                                height: height * 0.1,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Constants.loggedInUser?.imageurl
                                                  .toString() ==
                                              "null"
                                          ? ClipOval(
                                            child: Image.asset(
                                                'assets/images/profile.png',width: 80,
                                              height: 80,),
                                          )
                                          : ClipOval(
                                            child: CachedNetworkImage(
                                                imageUrl: Constants
                                                    .loggedInUser!.imageurl
                                                    .toString(),
                                                fit: BoxFit.fill,
                                                width: 80,
                                                height: 80,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    ClipOval(
                                                      child: Image.asset(
                                                          'assets/images/profile.png',width: 80,
                                                        height: 80,),
                                                    ),
                                              ),
                                          ),
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      right: 0.0,
                                      child: SvgPicture.asset(AppIcons.addIcon),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              data.name!,
                              style: poppinsSemiBold.copyWith(
                                fontSize: 16,
                                color: AppColors.greenDarkColor,
                              ),
                            ),
                            SizedBox(height: height * 0.003),
                            Text(
                              data.email!,
                              style: poppinsRegular.copyWith(
                                fontSize: 14,
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///
                      SizedBox(height: height * 0.024),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withOpacity(0.17),
                              blurRadius: 32,
                              offset: const Offset(0, 6.0),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileDataWidget(heading: 'Full name', valueText: data.name!),
                            ProfileDataWidget(heading: 'Phone number', valueText: data.contact!),
                            ProfileDataWidget(isBorder: false, heading: 'Address', valueText: data.permanentAddress ?? 'N/A'),
                          ],
                        ),
                      ),

                      ///
                      SizedBox(height: height * 0.1),
                      bottomButtons(),
                      SizedBox(height: height * 0.01),

                    ],
                  ),
                ),
              );
      },
    );
  }

  bottomButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              showCustomDialog(context, 0, 'Delete Account',
                  "Are you sure you want to delete your account? This can't be undone");
            },
            child: Row(
              children: [
                SvgPicture.asset(AppIcons.delete, height: 24),
                const SizedBox(width: 10),
                Text(
                  'Delete Account',
                  style: poppinsMedium.copyWith(
                    fontSize: 16,
                    color: AppColors.redColor,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              showCustomDialog(
                  context, 1, 'Logout', 'Are you sure do you want to Signout?');
            },
            child: Row(
              children: [
                SvgPicture.asset(AppIcons.logout, height: 24),
                const SizedBox(width: 12),
                Text(
                  'Logout',
                  style: poppinsMedium.copyWith(
                    fontSize: 16,
                    color: AppColors.redColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future logOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Constants.loggedInUser = null;
    Constants.currentOrder = null;
    Constants.selectedOrderRequest = null;
    OneSignal.shared.logoutEmail();
//    OneSignal.shared.disablePush(true);
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/intro', (Route<dynamic> route) => false);
    }
  }

  void showCustomDialog(
      BuildContext context, int index, String heading, String text) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// close icon
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 10),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: const ImageIcon(
                          AssetImage("assets/icons/cross.png"),
                          color: Color(0xff383838),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    heading,
                    style: poppinsSemiBold.copyWith(
                      fontSize: 24,
                      color: AppColors.redColor,
                    ),
                  ),

                  ///
                  const SizedBox(height: 11),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: poppinsRegular.copyWith(
                        fontSize: 16,
                        color: AppColors.blackColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// divider
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(
                      thickness: 0.6,
                      height: 0.6,
                      color: AppColors.borderColor,
                    ),
                  ),

                  ///
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.redLightColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            thickness: 1,
                            width: 1,
                            color: AppColors.borderColor,
                          ),
                        ),

                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.pop(context);
                                  context
                                      .read<AuthenticationService>()
                                      .deleteUser(context, mounted);
                                } else {
                                  Navigator.pop(context);
                                  logOutUser();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Center(
                                  child: Text(
                                    'Yes',
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.primaryOneColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
