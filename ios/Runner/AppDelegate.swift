import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Listen for Universal Links
    if let userActivityDict = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any] {
      for activity in userActivityDict.values where activity is NSUserActivity {
        let userActivity = activity as! NSUserActivity
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let incomingURL = userActivity.webpageURL {
          self.handleIncomingLink(url: incomingURL)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let incomingURL = userActivity.webpageURL {
      self.handleIncomingLink(url: incomingURL)
      return true
    }
    return false
  }

  private func handleIncomingLink(url: URL) {
    // Use the existing 'flutter' property from FlutterAppDelegate which is the FlutterEngine
    let channel = FlutterMethodChannel(name: "app/isms/deeplink", binaryMessenger: flutter.binaryMessenger)
    channel.invokeMethod("handleIncomingLink", arguments: url.absoluteString)
  }
}
