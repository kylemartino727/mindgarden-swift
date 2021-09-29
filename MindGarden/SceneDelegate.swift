//
//  SceneDelegate.swift
//  MindGarden
//
//  Created by Mark Jones on 5/25/21.
//

import UIKit
import SwiftUI
import AppsFlyerLib
import FirebaseDynamicLinks
import Firebase
import Foundation
import OneSignal

var numberOfMeds = 0
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    static let userModel = UserViewModel()
    static let bonusModel = BonusViewModel(userModel: userModel)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // Create the SwiftUI view that provides the window contents.
//        UserDefaults.standard.setValue(false, forKey: "tappedRate")
//        UserDefaults.standard.setValue("gratitude", forKey: K.defaults.onboarding)
        if !UserDefaults.standard.bool(forKey: "showedNotif") {

            UserDefaults.standard.setValue(["White Daisy"], forKey: K.defaults.plants)
            UserDefaults.standard.setValue("White Daisy", forKey: K.defaults.selectedPlant)
            UserDefaults.standard.setValue("nature", forKey: "sound")
            UserDefaults.standard.setValue(50, forKey: "coins")
            UserDefaults.standard.setValue(2, forKey: "frequency")
            UserDefaults.standard.setValue(["gratitude", "smiling", "loving", "breathing", "present"], forKey: "notifTypes")
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            UserDefaults.standard.setValue(formatter.string(from: Date()), forKey: "joinDate")
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    Analytics.shared.log(event: .onboarding_notification_on)
                    NotificationHelper.addOneDay()
                    NotificationHelper.addThreeDay()
                } else {
                    Analytics.shared.log(event: .onboarding_notification_off)
                }
                UserDefaults.standard.setValue(true, forKey: "showedNotif")
            }
        }
        Analytics.shared.log(event: .launchedApp)


        let router = ViewRouter()
        let medModel = MeditationViewModel()

        let gardenModel = GardenViewModel()
        let profileModel = ProfileViewModel()
        let authModel =  AuthenticationViewModel(userModel:  SceneDelegate.userModel, viewRouter: router)
        medModel.updateSelf()
        SceneDelegate.userModel.updateSelf()
        gardenModel.updateSelf()
        SceneDelegate.bonusModel.updateBonus()

        if UserDefaults.standard.string(forKey: K.defaults.onboarding) != "done" {
            SceneDelegate.bonusModel.totalBonuses = 1
            SceneDelegate.bonusModel.sevenDayProgress = 0.1
            SceneDelegate.bonusModel.thirtyDayProgress = 0.08
        }

        let contentView = ContentView(bonusModel:  SceneDelegate.bonusModel, profileModel: profileModel, authModel: authModel)

        // Use a UIHostingController as window root view controller.
        let rootHost = UIHostingController(rootView: contentView
                                            .environmentObject(router)
                                            .environmentObject(medModel)
                                            .environmentObject(SceneDelegate.userModel)
                                            .environmentObject(gardenModel))
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootHost
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        numberOfMeds = Int.random(in: 185..<211)
        var launchNum = UserDefaults.standard.integer(forKey: "launchNumber")
        launchNum += 1
        launchedApp = true
        UserDefaults.standard.setValue(launchNum, forKey: "launchNumber")
        Analytics.shared.log(event: .sceneDidBecomeActive)
        DispatchQueue.main.async {
            SceneDelegate.bonusModel.bonusTimer?.invalidate()
            SceneDelegate.bonusModel.bonusTimer = nil
        }
        SceneDelegate.bonusModel.updateBonus()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // use this to add friends
        if let incomingUrl = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl) { (dynamicLink, error) in
                guard error == nil else {
                    print("Found an error \(error!.localizedDescription)")
                    return
                }
//                if let dynamicLink = dynamicLink {
//                    print(self.handlIncomingDynamicLink(dynamicLink), "gooat")
//                }
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            AppsFlyerLib.shared().handleOpen(url, options: nil)
        }
        for context in URLContexts {
            if context.url.scheme == "christmas" {
                UserDefaults.standard.setValue(true, forKey: "christmasLink")
            } else if context.url.scheme == "intro" {
                UserDefaults.standard.setValue(true, forKey: "introLink")
            } else if context.url.scheme == "happiness" {
                UserDefaults.standard.setValue(true, forKey: "happinessLink")
            } else if context.url.scheme == "gratitude" {
                NotificationCenter.default.post(name: Notification.Name("gratitude"), object: nil)
            } else if context.url.scheme == "meditate" {
                NotificationCenter.default.post(name: Notification.Name("meditate"), object: nil)
            } else if context.url.scheme == "mood" {
                NotificationCenter.default.post(name: Notification.Name("mood"), object: nil)
            } else if context.url.scheme == "pro" {
                NotificationCenter.default.post(name: Notification.Name("pro"), object: nil)
            }
        }
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
}

extension URL {
 func valueOf(_ queryParamaterName: String) -> String? {
 guard let url = URLComponents(string: self.absoluteString) else { return nil }
 return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value?.removingPercentEncoding?.removingPercentEncoding
 }
}


