import UIKit
import Flutter
import GoogleMaps  // Add google maps import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyCGAovog94J5-D7myw2wu-BqUb9FMO6eKM")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
