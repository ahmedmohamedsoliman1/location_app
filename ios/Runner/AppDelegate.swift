import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [GMSServices provideAPIKey:@"AIzaSyCvS8iisJvvwPHOeMJgL5hcmn_h4WPYVVU"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
