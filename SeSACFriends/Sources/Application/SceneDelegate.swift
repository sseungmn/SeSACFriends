//
//  SceneDelegate.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        var entryViewController: UIViewController
        if AuthUserDefaults.isUser {
            entryViewController = MainViewController()
        } else if AuthUserDefaults.idtoken.isEmpty {
            entryViewController = OnboardingViewController()
        } else {
            entryViewController = NicknameViewController()
        }
        
        let nav = UINavigationController(rootViewController: entryViewController)
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
