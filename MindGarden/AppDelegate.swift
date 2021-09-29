//
//  AppDelegate.swift
//  MindGarden
//
//  Created by Mark Jones on 5/25/21.
//

import UIKit
import Firebase
import GoogleSignIn
import AppsFlyerLib
import Purchases
import FirebaseDynamicLinks
import Amplitude
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        // Appsflyer
        AppsFlyerLib.shared().appsFlyerDevKey = "MuYPR9jvHqxu7TzZCrTNcn"
        AppsFlyerLib.shared().appleAppID = "1588582890"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true



        Amplitude.instance().trackingSessionEvents = true
        // Initialize SDK
        Amplitude.instance().initializeApiKey("76399802bdea5c85e4908f0a1b922bda")
        // Set userId
        // Log an event

        sendLaunch()
        Purchases.logLevel = .debug
        Purchases.automaticAppleSearchAdsAttributionCollection = true
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
         // OneSignal initialization
         OneSignal.initWithLaunchOptions(launchOptions)
         OneSignal.setAppId("7f964cf0-550e-426f-831e-468b9a02f012")
        let userId = UserDefaults.standard.string(forKey: "userId")
        if userId != nil  && userId != ""  {
            Purchases.configure(withAPIKey: "wuPOzKiCUvKWUtiHEFRRPJoksAdxJMLG", appUserID: userId)
            Purchases.shared.setOnesignalID(userId)
            Amplitude.instance().setUserId(userId)
        } else {
            let id = UUID().uuidString
            OneSignal.setExternalUserId(id)
            UserDefaults.standard.setValue(id, forKey: "userId")
            Purchases.configure(withAPIKey: "wuPOzKiCUvKWUtiHEFRRPJoksAdxJMLG", appUserID: id)
            Purchases.shared.setOnesignalID(id)
            Amplitude.instance().setUserId(id)
        }
        Purchases.shared.collectDeviceIdentifiers()

        // Set the Appsflyer Id
        Purchases.shared.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())
         // promptForPushNotifications will show the native iOS notification permission prompt.
         // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func handlIncomingDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
      guard let dynamicLink = dynamicLink else { return false }
      guard let deepLink = dynamicLink.url else { return false }
      let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
      let invitedBy = queryItems?.filter({(item) in item.name == "invitedby"}).first?.value
      let user = Auth.auth().currentUser
      // If the user isn't signed in and the app was opened via an invitation
      // link, sign in the user anonymously and record the referrer UID in the
      // user's RTDB record.
      if user == nil && invitedBy != nil {
        Auth.auth().signInAnonymously() { (user, error) in
//          if let user = user {
//            let userRecord = Database.database().reference().child("users").child(user.uid)
//            userRecord.child("referred_by").setValue(invitedBy)
//            if dynamicLink.matchConfidence == .weak {
//              // If the Dynamic Link has a weak match confidence, it is possible
//              // that the current device isn't the same device on which the invitation
//              // link was originally opened. The way you handle this situation
//              // depends on your app, but in general, you should avoid exposing
//              // personal information, such as the referrer's email address, to
//              // the user.
//            }
//          }
        }
      }
      return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let deepLink = url.valueOf("deep_link_id") ?? ""
        if deepLink != "" {
            guard let urlComponents = URLComponents(string: deepLink), let queryItems = urlComponents.queryItems else { return false }
            for item in queryItems{
                if item.name == "referral" {
                    Analytics.shared.log(event: .onboarding_came_from_referral)
                    UserDefaults.standard.setValue(item.value ?? "", forKey: K.defaults.referred)
                }
            }
        }
        return GIDSignIn.sharedInstance().handle(url)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return false
    }
}
//MARK: AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate{
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ installData: [AnyHashable: Any]) {
//        print("onConversionDataSuccess data:")
//        for (key, value) in installData {
//            print(key, ":", value)
//        }
        if let status = installData["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = installData["media_source"],
                   let campaign = installData["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = installData["is_first_launch"] as? Bool,
               is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    func onConversionDataFail(_ error: Error) {
        print(error)
    }
    //Handle Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]) {
        //Handle Deep Link Data
//        print("onAppOpenAttribution data:")
//        for (key, value) in attributionData {
//            print(key, ":",value)
//        }
    }
    func onAppOpenAttributionFailure(_ error: Error) {
        print(error)
    }
}
