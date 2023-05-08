# Flutter SDK Integration

> Run the sample App using below command

```ruby
flutter pub get

flutter run
```

## Android – Native code setup

The code setup for Flutter project relates to a set of configuration setting applicable for Flutter (application/app) to work well as per the functions.

### Installing the SDK
Add plugin via CLI 
```ruby
flutter pub add refluttersdk
```

### Initializing the SDK
- In order to initialize the SDK create an Application class as below

```java
import android.app.Application
import com.resul.refluttersdk.RefluttersdkPlugin
class ProjectApplication: Application() {
    override fun onCreate() {
    super.onCreate()
    RefluttersdkPlugin().initReSdk(this)

}
}
```
Note: Please add the ProjectApplication class to AndroidManifest.xml

### Notification message delivery
- Create an FCM project to proceed with this link https://firebase.google.com/docs/cloud-messaging/android/client.
- Add the firebase dependencies in the ‘app/build.gradle’.
```java
implementation 'com.google.firebase:firebase-messaging:20.1.0'

```
- Create a new FCM Receiver class extension with ‘FirebaseMessagingService’ and override the ‘onMessageReceived’ method in the class.
Example
```java
import com.resul.refluttersdk.RefluttersdkPlugin
class MessagingService:FirebaseMessagingService () {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
	super.onMessageReceived(remoteMessage)
	if(RefluttersdkPlugin().clientMessageReceiver(remoteMessage,this))
         {
          return;
         }
    }
}

```
- Create the ‘FCM Receiver’ class and connect to ‘Androidmainfest.xml’ file.
```ruby
<!--The receiver receives FCM notification -->
<service
android:name="<Firebase receiver class>"    
android:exported="false"    
android:directBootAware="true">
<intent-filter>
<actionandroid:name="com.google.firebase.MESSAGING_EVENT"/>
</intent-filter>
</service>

```
The ‘onMessageReceived’ method handles the presentation of Resulticks notification, In-app notification, and the activity level screen navigation. Pass through the custom parameters and the fragment name through the activity bundle intent.

### Deep linking/Deferred deep linking
For the mobile app, deep linking consists of using a uniform resource identifier (URI) that links to a specific location within a mobile app rather than launching the app.
>1.	Paste the deep linking ‘AndroidManifest.xml’ inside the intentfilter.
Example:
```ruby
<intent-filter android:autoVerify="true">
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<category android:name="android.intent.category.BROWSABLE" />
<data
android:host="<host>"
android:scheme="<scheme>"/>
</intent-filter>

```

Example - JSON String data – ‘activityName’, ‘fragmentName’, ‘customParams’.

Based on the above code snippet

**Method – ‘onInstallDataReceived’**

Use the ‘onInstallDataReceived’ method for new installation to occur through the smart-link.

**Method – ‘onDeepLinkData’**

Use the ‘onDeepLinkData’ method to trigger an activity when a user clicks on an already installed app followed by a click on the smartlink.

Sample – JSON string:


```json
{"activityName":"test.com.myapplication.MainActivity","fragmentName":"HomeFragment","customParams":{"customParamKey1":"Value1","customParamKey2":100}}

```

### App configuration

The app configuration relates to a set of configuration settings applicable for an application/app to work well as per the functions.

Perform the listed steps for configuring the app.

- Paste the metadata ‘AndroidManifest.xml’ inside the application tag.

```ruby
<!-- Application Class-->
<application
android:name=`<application class name>`
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name" 
android:theme="@style/AppTheme">

<meta-data
android:name="resulticks.default_notification_icon"
android:resource="@drawable/<Notification-Icon>"/>

<meta-data
android:name="resulticks.default_notification_icon_transparent"
android:resource="@drawable/<Notification-Icon>"/>


<meta-data
android:name="resulticks.default_notification_color"
android:resource="@color/<Notification_color "/>

<!-- Setting global variable for Resulticks API key -->
<meta-data
android:name="resulticks.key"
android:value="api_key_<App Id>" />
</application>
```

## iOS – Native code setup

### Initializing the SDK

- Perform the steps listed to set up the native iOS code

- Initialize SDK

```ruby
RefluttersdkPlugin().initWithSDK("<app_id>")
```
For the App id (API key), refer to the App credential's table

**Sample – ForiOS ver.13 and below**

```ruby
class AppDelegate: UIResponder, UIApplicationDelegate {
func application(
  _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

	RefluttersdkPlugin().initWithSDK("<app_id>")
}
```

**Sample - For iOS ver.13 and above**

```ruby
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {    
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {	
	RefluttersdkPlugin().initWithSDK("<app_id>")
}
}
```

### Dynamic link

Firebase dynamic link adopts a kind of deferred deep-linking approach for iOS. Firebase dynamic link ‘match_type’ is unique to identify the correct installation

For more details, refer to the link: https://firebase.google.com/docs/dynamic-links

Send the dynamic- link details through the SDK registration

**Dynamic-link data format:** [String: Any]

Consider the screenname as a ‘string’, customParams as a ‘JSON’ string.

```ruby
["screenName": "SIDOrder", "customParams": "{‘screenId’: 11, ‘productId’: 1029}", “isNewInstall”: true,
“isDeepLink”: true]
```

**Case 1: When app installation is available**

The Firebase dynamic link opens the installed app and redirects to the respective screen set when a user clicks on the Firebase dynamic link.

**Case 2: When the app installation is not available**

When a user clicks on the dynamic link, it redirects to the App store. After installing the app and launching the application, it redirects to the respective screen set

Example:  Using ‘AppDelegate’ method below iOS ver.13

```ruby
func application(_app: UIApplication, open url: URL,options:[UIApplicationOpenURLOptionsKey: Any]) -> Bool {        
	RefluttersdkPlugin.open(url)
	return true
}
```

**Dynamic link receiver**

```ruby
func application(_ application: UIApplication, willContinueUserActivityWithType	userActivityType: String) ->Bool {
	if userActivityType == NSUserActivityTypeBrowsingWeb {
		return true
	}
}
```

```ruby
funcapplication(_ application: UIApplication, continue userActivity:NSUserActivity,    restorationHandler: @escaping ([Any]?) - >Void) ->Bool {
         //Dynamic Link
	RefluttersdkPlugin.handleDynamicLink(with: userActivity) { 
        data in
       } failureHandler: { err in

        }
		return false
	}
```

Example: Using the **‘SceneDelegate’** method for **iOS ver.13** and above

```ruby
func scene(_scene: UIScene, openURLContextsURLContexts: Set<UIOpenURLContext>) {
		if let url = URLContexts.first?.url {            
			RefluttersdkPlugin.open(url)
		 }
	}
```

## Notification & Smartlink receiver

Use the below codes in dart for handling the notifications and deeplinking.

### Notification & Deeplinking listener

Add the below code in your initial page or routing page

```dart
import ‘package:refluttersdk/refluttersdk.dart’;
final _refluttersdk=Refluttersdk();
_refluttersdk.listener((data){
//Do your work
});
```

## Flutter – Dart code setup

### Method – sdkRegistration

1. In order to use the functions, we have to import a plugin class within the dart file your are going to use the function

Example

```dart
import ‘package:flutter/material.dart’;
import ‘package:refluttersdk/refluttersdk.dart’;

final _reflutterSdk=Refluttersdk();
```

1. Set the call in the **‘sdkRegistration’** method for SDK registration or after initiating the log-in with the custom method

```dart
var userData = {
	"userUniqueId": "", // Mandatory
      "deviceToken":"<fcm token>",//Mandatory
	"name": "<user_name>", // String
	"email": "<email>", // String
	"phone": "<phone_number>", // String
	"age": "<age>", // String
	"gender": "<gender>", // String
"profileUrl": "<url>", // String
	"dob": "<date of birth>", // String
	"education": "<education>", // String
	"employed": "<true||false>", // Bool
	"married": "<true||false>", // Bool
	"dynamicLink": {// Only for iOS
	"applinks": "<applinks from firebase dynamiclink>", // String
	"storeId": "<store id for the application>" // String
	};
	_reflutterSdk.sdkRegisteration(userData);
```

Enable the following parameters as mandatory at the code level

The parameters ‘Unique id’ and the ‘Token’ are considered mandatory.

The SDK registration must be called at every login when the login action is a success or when implementing a similar function in the application

**Note** : Implement the app as a dynamic link, and then pass two parameters listed below

**‘applinks’** – The ‘applinks’ refers to the dynamic link host. Get the link while creating the dynamic link in the Firebase console

**‘storeId’**: The ‘storeId’ refers to the appstore ‘app_id’. While uploading the app to the Appstore is done, it generates the identifier (Id)

## Update Push Token

Update the Device token here

**Method – updatePushToken**

```dart
_reflutterSdk.updatePushToken(“fcmToken”);
```

## Custom event tracking

Track the events using the ‘customEvent’ method

**Method – ‘customEvent’**

```dart
var eventData =”payment”
_reflutterSdk.customEvent(eventData);
```
**Method – ‘customEventWithData’

```dart
var eventData = {
		"name": "payment",
		 "data": {"id": "2d43", "price": "477"}
	};
_reflutterSdk. customEventWithData(eventData);
```

## Method - locationUpdate

**Method –‘locationUpdate’**

```dart
double lat = 13.0827,
		double lang = 80.2707,
	
	_reflutterSdk.locationUpdate(lat,lang);	
```

## Method - appConversion

Use the ‘appConversion’ method to track the actions/activities of the users.

**Method - For conversation tracking**

```dart
_reflutterSdk.appConversion();
```

**Method - For conversation trackingWithData**

```dart
Map appConvertionData={
    “name”:”xyz”,
    “data”:{
     “age”:”23”,
     “city”:”YYY”
}
};
_reflutterSdk.appConversionWithData(appConvertionData);
```

## Method - screenTracking

Use the ‘screenTracking’ method for tracking the screen usage by a user

**Method - screenTracking**

```dart
_reflutterSdk.screenTracking(“ScreenName”);
```

**Notification list**

**Method –getNotificationList**

Use the ‘getNotificationList’ method to get the notification list data

```dart
var notificationList = await _reflutterSdk.getNotificationList();
```

**Example for notification list**

```ruby
[
  {
    "campaignId": "1582712270839","notificationId": "1","title": "Notification title","subtitle": "Notification Subtitle","body": "Notification body","notificationImageUrl": "Media_URL","url": "Media_URL",
    "screenUrl": "HomeViewController:app.HomeViewController","customParams": "{\"customParamKey1\":\"Value1\",\"customParamKey2\":100}","timeStamp": "1593107578.784845",
    "mobileFriendlyUrl": "https://app.smartdx.co","customActions": "[{\"actionBgColor\":\"#FFFFFF\",\"actionType\":\"call\",\"actionTextColor\":\"#000000\",\"actionId\":6,\"url\":\"9123123123\",\"actionName\":\"Communicate\"},{\"actionBgColor\":\"#FFFFFF\",\"actionType\":\"maybelater\",\"duration\": \"1 Minute(s)\",\"actionTextColor\":\"#000000\",\"actionId\":7,\"url\":\"https:\\/\\/www.resulticks.com\\/\",\"actionName\":\"May be later\"}]","pushType": "2","sourceType": "3","bannerStyle": "2","isRead": true
  }
]
```

**‘sourceType’** The source type can be either ‘Web url’, video/audio, gif, or an image

**‘pushType’** The different push types available for notification are alert/rich push, ‘Inapp’ push, and ‘Inbox’ push notifications

**‘bannerStyle’** The different banner styles available are full screen, middle of the screen, top of the screen and end (bottom) of the screen

**Delete notification**

**Method 1–‘deleteNotificationByCampaignId’**

```dart
_reflutterSdk.deleteNotificationByCampaignId(campaingId);
```

**Notification count and read status**

**Method –‘getReadNotificationCount’

Use the ‘getReadNotificationCount’ method for receiving the read notification count from Resulticks SDK

```dart
var  _readCount =await _reflutterSdk.getReadNotificationcount();
```

**Method –‘getUnReadNotificationCount’**

Use the ‘getUnReadNotificationCount’ method for receiving the read notification count from Resulticks SDK

```dart
var _unReadCount =await  _reflutterSdk.getUnReadNotificationcount();
```

**Method –‘unReadNotification’**

Use the ‘unReadNotification’ method to set notification status to ‘No’

```dart
_reflutterSdk.unReadNotification(“CampaignId”);
```

**Method –‘readNotification’**

Use the ‘readNotification’ method to set notification status to ‘Yes’

```dart
_reflutterSdk.readNotification(“CampaignId”);
```

## Implementing service extensions

To add the new notification service extension go to

- File -> New -> Target
- Click the target and select the iOS platform then select `Notification Service Extension` it will ask you to activate the extension. Click activate.
- It will create one folder with Swift file and Info plist
- Add below code to swift file

```swift
import UserNotifications
import REIOSSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

   override funcdidReceive(_ request: UNNotificationRequest, 
withContentHandlercontentHandler: @escaping (UNNotificationContent) -> Void) {

self.contentHandler = contentHandler
self.bestAttemptContent=(request.content.mutableCopy()as? 
UNMutableNotificationContent)
REiosHandler.presentServiceExtension(request: request) { content in
contentHandler(content)
        }
    }

    override funcserviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler,
           let bestAttemptContent =  bestAttemptContent {
contentHandler(bestAttemptContent)
        }
    }  
}
```
- Verify the info plist whether it has below code if not then add it to the info plist

```ruby
<dict>
<key>NSExtensionPointIdentifier</key>
<string>com.apple.usernotifications.service</string>
<key>NSExtensionPrincipalClass</key>
<string>$(PRODUCT_MODULE_NAME).NotificationService</string>
</dict>
```

## Implementing content extensions

To add the new notification service extension, Go to

- File -> New -> Target
- Click the target and select the iOS platform then select `Notification Content Extension` it will ask you to activate the extension. Click activate
- It will create one folder with Swift file, MainInterface and Info plist
- Add below code to swift file

```swift
import UIKit
import UserNotifications
import UserNotificationsUI
import REIOSSDK

class NotificationViewController: UIViewController, UNNotificationContentExtension, 
REiosContentExtensionReceiver {

    override funcviewDidLoad() {
super.viewDidLoad()
REiosHandler.contentExtDelegate = self
    }

funcdidReceive(_ notification: UNNotification) {
        letdynamicLink=["applinks":"visionretail.page.link","storeId": "1289654399", "appBundleId":"com.resulticks.visionretail" ]
REiosHandler.presnetContentExtension(vc: self, notification: notification, deeplinkData: dynamicLink) { height in
        }
    }    
funcdidCloseContentExtention() {
        if #available(iOSApplicationExtension 12.0, *) {
            self.extensionContext?.dismissNotificationContentExtension()
        } else {
            // Fallback on earlier versions
        }
    }   
funcdidReceive(_response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
    }
}
```

- Verify the info plistand add UNNotificationExtensionCategory to **Resul**

```ruby
<dict>
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionAttributes</key>
		<dict>
			<key>UNNotificationExtensionCategory</key>
			<string>Resul</string>
			<key>UNNotificationExtensionDefaultContentHidden</key>
			<true/>
			<key>UNNotificationExtensionInitialContentSizeRatio</key>
			<real>1</real>
			<key>UNNotificationExtensionUserInteractionEnabled</key>
			<true/>
		</dict>
		<key>NSExtensionMainStoryboard</key>
		<string>MainInterface</string>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.usernotifications.content-extension</string>
	</dict>
</dict>
```

- Open MainInterface and delete the UILabel from the viewcontroller

## Deployment of iOS app

Perform the steps listed to upload the mobile iOS app with ‘bitcode’.

**Bitcode setup**

- Enable Bitcode in iOS app projects and cocoapods projects. (If it is available)
- Navigate to build settings and search for **“Other C Flags.”**
- Click on the add ‘+’ button and add the parameter **“-fembed-bitcode.”**
- In the ‘Build settings,’ add the user-defined setting
- Add the new key mentioned below and set the value to **‘bitcode.’**

```swift
“BITCODE_GENERATION_MODE” = bitcode
```

















































































































     
