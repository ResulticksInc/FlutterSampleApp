import UIKit
import Flutter
import Firebase
import refluttersdk

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    UNUserNotificationCenter.current().delegate = self
    RefluttersdkPlugin().initWithSDK("7def9b46-cb52-48c7-a858-5213b2cb5e72")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    override func application(_ _app: UIApplication, open url:     URL,options:[UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        RefluttersdkPlugin.open(url)
        return true
    }
    override func application(_ application: UIApplication, willContinueUserActivityWithType                                userActivityType: String) ->Bool {
            if userActivityType == NSUserActivityTypeBrowsingWeb {
            return true
            }
        return false
    }
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        RefluttersdkPlugin.handleDynamicLink(with: userActivity) {
            data in
           } failureHandler: { err in

            }
            return false
    }
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        RefluttersdkPlugin.willPresent(notification) { options in
            completionHandler(options)
        }
    }
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let _userInfo = userInfo as? [String: Any] {
            RefluttersdkPlugin.didReceiveRemoteNotification(userInfo)
            completionHandler(.newData)
        }

        
       
    }
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        RefluttersdkPlugin.didReceive(response)
        completionHandler()
    }
}
