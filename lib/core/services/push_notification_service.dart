import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

class PushNotificationService {
  // ignore: prefer_final_fields
  bool _requiresConsent = false, mounted = true;

  Future<void> setupOneSignal() async {
    await OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
    OneSignal.shared.setExternalUserId(const Uuid().v4()).then((results) {
      // ignore: unnecessary_null_comparison
      if (results == null) return;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    OneSignal.shared.setRequiresUserPrivacyConsent(_requiresConsent);
    _requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    setupOneSignal();
  }
}
