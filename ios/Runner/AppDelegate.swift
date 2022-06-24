import UIKit
import GoogleMobileAds
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "3f3f9ebecc9c45504738aac68ab5abc2" ]
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
