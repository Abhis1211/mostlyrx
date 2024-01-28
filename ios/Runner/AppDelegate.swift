import UIKit
import Flutter
//import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  //  GMSServices.provideAPIKey("AIzaSyB7ox1E554U1C3SNVgnwACu1UtycHCDWtc")
      UNUserNotificationCenter.current().delegate = self
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
