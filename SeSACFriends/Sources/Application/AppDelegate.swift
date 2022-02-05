//
//  AppDelegate.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit
import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Auth.auth().languageCode = "kr"
        
        registerNotification(application)
        registerMessaging(application)
        setIQKeyboardManager()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

}

// MARK: Register to Fireabse
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func registerMessaging(_ application: UIApplication) {
        Messaging.messaging().delegate = self
    }
}

// MARK: Receieve AutoRefresh
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debug(title: "Firebase registration token", String(describing: fcmToken))
        guard let FCMtoken = fcmToken else { return }
        AuthUserDefaults.FCMtoken = FCMtoken
    }
}

// MARK: IQKeyboardManager
extension AppDelegate {
    func setIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
