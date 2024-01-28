import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/constants/app_text_field_v2.dart';
import 'package:mostlyrx/core/models/user.dart';
import 'package:mostlyrx/core/services/api.dart';
import 'package:mostlyrx/core/services/authentication_service.dart';
import 'package:mostlyrx/core/services/image_picker_utils.dart';
import 'package:mostlyrx/ui/constants/colors.dart';
import 'package:mostlyrx/ui/constants/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditor extends StatefulWidget {
  const ProfileEditor({Key? key}) : super(key: key);

  @override
  State<ProfileEditor> createState() => ProfileEditorState();
}

class ProfileEditorState extends State<ProfileEditor> {
  XFile? _license;

  XFile? _licenseBack;
  final ImagePicker _picker = ImagePicker();
  XFile? attachImage;
  String? experience;
  final _profs = <String, XFile?>{
    'image': null,
    'Second': null,
    'Thired': null,
    'Fourth': null,
  };
  @override
  void initState() {
    SharedPreferences.getInstance().then((prf) {
      setState(() {
        experience = prf.getString('exp');
      });
    });
    super.initState();
  }

  List<String> companys = [
    'Uber',
    'Door',
    'Lift',
    'Dash',
    'Amazon delivery',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    print(Constants.loggedInUser!.imageurl);
    return Consumer<User?>(builder: (context, user, _) {
      var docProvided = user?.documentsProvided ?? false;

      return Scaffold(
        extendBodyBehindAppBar: true,
        //appBar:
        body: Stack(
          children: [
            Image.asset('assets/vectors/Vector 4.png',
                width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
            Positioned(
                bottom: 0,
                child: Image.asset('assets/vectors/Vector 1.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth)),
            Positioned(
                bottom: MediaQuery.of(context).size.height * .65,
                child: Image.asset('assets/vectors/vector 3.png')),
            Positioned(
                bottom: 0, child: Image.asset('assets/vectors/Vector 2.png')),
            //*USING ALL OF THIS 3 WIDGET [SizedBox,Column,SingleChildScrollView] to get better control over the children widgets
            //*PAGE
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppBar(
                      centerTitle: false,
                      toolbarHeight: 70,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.5),
                      toolbarOpacity: 0.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))),
                      leadingWidth: 100,
                      backgroundColor: Colors.white,
                      actions: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            width: 75,
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                                child: Text('Edit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))))
                      ],
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Image.asset('assets/images/app_logo.png',
                            width: 90, height: 80),
                      ),
                    ),
                    if (!user!.isApproved)
                      ListTile(
                        tileColor: Colors.red,
                        title: Center(
                            child: Text(
                                docProvided
                                    ? 'Your document is been Processed'
                                    : 'Please upload Necessary document',
                                style: const TextStyle(color: Colors.white))),
                      ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        attachImage =
                            await ImagePickerUtils.showPicker(context);
                        setState(() {});
//                        _uploadProfile();
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: attachImage == null &&
                                  Constants.loggedInUser?.imageurl
                                      .toString() ==
                                      "null"
                                  ? ClipOval(child: Image.asset('assets/images/profile.png',width: 100,height: 100,))
                                  : attachImage != null
                                  ? Image.file(File(attachImage!.path),width: 100,height: 100,)
                                  : ClipOval(
                                    child: CachedNetworkImage(
                                imageUrl: Constants
                                      .loggedInUser!.imageurl
                                      .toString(),
                                        fit: BoxFit.fill,
                                      width: 100,height: 100,
                                placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                errorWidget: (context, url,
                                      error) =>
                                    ClipOval(
                                        child: Image.asset(
                                            'assets/images/profile.png',width: 100,height: 100,),
                                      ),
                              ),
                                  ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 6,
                              child: Image.asset(
                                "assets/icons/image_upload.png",
                                width: 35,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(user.name!,
                        style: AppTextStyles.normal.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500)),
                    AppTextFieldV2(title: 'Email', hintText: user.email!),
                    AppTextFieldV2(
                        title: 'Address', hintText: user.permanentAddress!),
                    AppTextFieldV2(
                        title: 'Phone Number', hintText: '\t${user.contact!}'),
                    if (!docProvided)
                      Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: 1.9,
                            child: Text('Upload Driving License',
                                style: TextStyle(
                                    color: Color(0xFF43A047),
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UploadContainer(
                                  text: 'Front',
                                  doc: _license,
                                  removeButton: () {
                                    setState(() {
                                      _license = null;
                                    });
                                  },
                                  onTap: () async {
                                    _license =
                                        await ImagePickerUtils.showPicker(
                                            context);
                                    setState(() {});
                                  }),
                              UploadContainer(
                                text: 'Back',
                                doc: _licenseBack,
                                removeButton: () {
                                  setState(() {
                                    _licenseBack = null;
                                  });
                                },
                                onTap: () async {
                                  _licenseBack =
                                      await ImagePickerUtils.showPicker(
                                          context);
                                  setState(() {});
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    const Align(
                      alignment: Alignment(-0.7, 0.5),
                      child: Text('Please select your Experience',
                          style: TextStyle(
                              color: Color(0xFF43A047),
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold)),
                    ),
                    _dropDownRow(
                        items: companys
                            .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e,
                                    style: const TextStyle(
                                        color: Color(0xFF747474)))))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            experience = val!;
                          });
                        }),
                    const SizedBox(height: 10),
                    if (!docProvided)
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                                'Prove of eligibility to work (work permit, sin card, police report etc)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF43A047),
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.bold)),
                          ),
                          GridView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              children: _profs.keys
                                  .map((item) => UploadContainer(
                                        isPlusSign: item != 'image',
                                        doc: _profs[item],
                                        onTap: () async {
                                          _profs[item] =
                                              await ImagePickerUtils.showPicker(
                                                  context);
                                          setState(() {});
                                        },
                                        removeButton: () {
                                          setState(() {
                                            _profs[item] = null;
                                          });
                                        },
                                        text: item,
                                      ))
                                  .toList()),
                          const SizedBox(height: 10),
                        ],
                      ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: const EdgeInsets.all(8.0)),
                        onPressed: () async {
                          Logger().v(Constants.loggedInUser?.id);
                          if (!docProvided) {
                            _uploadDoc();
                          }
                          if (experience != null && experience!.isNotEmpty) {
                            var prf = await SharedPreferences.getInstance();
                            await prf.setString('exp', experience!);
                            if (attachImage == null) {
                              Fluttertoast.showToast(msg: 'Updated');
                            }else{
                              _uploadProfile();
                            }
                          }else if(attachImage!=null){
                            _uploadProfile();
                          }
                        },
                        child: Text(
                          docProvided ? 'Update' : 'Upload Document',
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _uploadDoc() async {
    if (_license != null && _profs[_profs.keys.first] != null) {
      ImagePickerUtils.showWaitDialog('Uploading please wait', context);
      List<MultipartFile> licenses = [
        await MultipartFile.fromFile(_license!.path)
      ];
      List<MultipartFile> profFiles = [];
      if (_licenseBack != null) {
        licenses.add(await MultipartFile.fromFile(_licenseBack!.path,
            filename: _licenseBack!.path.split('/').last));
      }
      _profs.removeWhere((key, value) => value == null);
      for (var item in _profs.values) {
        profFiles.add(await MultipartFile.fromFile(item!.path));
      }
      Logger().v(profFiles.length);
      try {
        var uploaded =
            await Api().uploadFile(licenses: licenses, proofs: profFiles);
        if (uploaded && mounted) {
          AuthenticationService service = Provider.of(context, listen: false);
          var prefs = await SharedPreferences.getInstance();
          //* I Had to re login becuase the api dosn't send the Updated user info!!!!
          await service.login(
              prefs.getString('username')!, prefs.getString('password')!);
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false,
                arguments: 0);
          }
        } else {
          Navigator.pop(context);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Problem try again');
      }
    } else {
      showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) => SimpleDialog(
                title: Text(
                    'Missing ${_license == null ? 'Driver licence' : 'Prove of eligibility to workl'}',
                    textAlign: TextAlign.center),
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancale'))
                ],
              ));
    }
  }

  _dropDownRow({
    required List<DropdownMenuItem<String>> items,
    ValueChanged<String?>? onChanged,
  }) =>
      Container(
        width: MediaQuery.of(context).size.width * .9,
        padding: const EdgeInsets.only(left: 10, right: 13),
        margin: const EdgeInsets.only(top: 10, bottom: 13),
        decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(15)),
        child: DropdownButton<String>(
          value: experience ?? items[0].value,
          hint: const Text('Please select your Experience',
              style: TextStyle(
                  color: Color(0xFF43A047), fontWeight: FontWeight.bold)),
          onChanged: onChanged,
          icon: const RotatedBox(
            quarterTurns: 3,
            child: Icon(Icons.arrow_back_ios_rounded,
                size: 20, color: Colors.black),
          ),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          items: items,
        ),
      );

  _uploadProfile() async {
    if (attachImage != null) {
      ImagePickerUtils.showWaitDialog('Uploading please wait', context);
      List<MultipartFile> licenses = [];
      licenses.add(await MultipartFile.fromFile(attachImage!.path,
          filename: attachImage!.path.split('/').last));
      Logger().v(licenses.length);
      try {
        var uploaded = await Api().uploadProfile(
          licenses: licenses,
        );
        if (uploaded && mounted) {
          print('uploaded');
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'Updated');
          // AuthenticationService service = Provider.of(context, listen: false);
          // var prefs = await SharedPreferences.getInstance();
          // //* I Had to re login becuase the api dosn't send the Updated user info!!!!
          // await service.login(
          //     prefs.getString('username')!, prefs.getString('password')!);
          // if (mounted) {
          //   Navigator.pushNamedAndRemoveUntil(
          //       context, '/home', (route) => false,
          //       arguments: 0);
          // }
        } else {
          Navigator.pop(context);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Problem try again');
      }
    }
  }
}

class UploadContainer extends StatelessWidget {
  const UploadContainer(
      {Key? key,
      required XFile? doc,
      this.isPlusSign = false,
      required this.onTap,
      required this.text,
      required this.removeButton})
      : _prof = doc,
        super(key: key);
  final XFile? _prof;
  final VoidCallback onTap;
  final VoidCallback removeButton;
  final String text;
  final bool isPlusSign;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .43,
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(30)),
              child: isPlusSign && _prof == null
                  ? const Icon(
                      Icons.add,
                      size: 70,
                      color: Color(0xFF65C58D),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: profeImage(text)),
            ),
            if (_prof != null)
              Positioned(
                top: 3,
                right: 0,
                child: IconButton(
                    onPressed: removeButton,
                    icon: const Icon(Icons.remove_circle)),
              )
          ],
        ),
      ),
    );
  }

  List<Widget> profeImage(String text) {
    return _prof == null
        ? [
            const Icon(Icons.upload_file_outlined,
                size: 70, color: Color(0xFF65C58D)),
            Text(text, style: const TextStyle(color: Color(0xFF65C58D)))
          ]
        : [
            Image.file(File(_prof!.path),
                width: 180, height: 150, fit: BoxFit.cover)
          ];
  }
}
