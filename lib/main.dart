import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mostlyrx/core/constants/app_contstants.dart';
import 'package:mostlyrx/core/routes.dart';
import 'package:mostlyrx/firebase_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'provider_setup.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // AssetsAudioPlayer.newPlayer().open(
  //   Audio('assets/raw/alert.wav'),
  //   autoStart: true,
  //   showNotification: false,
  // );
  // AssetsAudioPlayer.newPlayer().play();
  // Soundpool pool = Soundpool.fromOptions(
  //     options: const SoundpoolOptions(streamType: StreamType.notification));
  // int soundId = await rootBundle
  //     .load('assets/raw/alert.wav')                                                                                                    \]]]]]]]]]]]
  //     .then((ByteData soundData) {
  //   return pool.load(soundData);
  // });
  print("here it is:${message.data}");
//  await pool.play(soundId);

  OneSignal.shared.clearOneSignalNotifications();
  FirebaseService().showNotifications(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  await OneSignal.shared.setAppId('39e303ed-4c76-4ec9-950d-276f5d0602da');
  print('===setup OneSignal===');
  var deviceState = (await OneSignal.shared.getDeviceState())!;
  OneSignal.shared.disablePush(false);
  print(deviceState.userId ?? 'token----> ');
  FirebaseService firebaseService = FirebaseService();
  await firebaseService.initLocalNotifications();
  await firebaseService.initFirebaseMessaging();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Constants.appNavigationKey,
        title: 'Mostly RX',
        theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Poppins'),
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
