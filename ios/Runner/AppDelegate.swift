import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseAppCheck
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Must run BEFORE GeneratedPluginRegistrant / Firebase configure,
    // otherwise the debug token is never logged.
    #if DEBUG
    AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
    #endif

    GMSServices.provideAPIKey("AIzaSyD99ddNqWGGU5yGesFBGS2dVuA-RIgVOxc")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
