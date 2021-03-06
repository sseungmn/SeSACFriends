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
        
        //        let entryViewController = UINavigationController(rootViewController: SearchTabmanController())
        var entryViewController: UIViewController
        if SesacUserDefaults.isUser {
            entryViewController = MainTabBarController()
        } else if SesacUserDefaults.idtoken.isEmpty {
            entryViewController = OnboardingViewController()
        } else {
            entryViewController = UINavigationController(rootViewController: NicknameViewController())
            entryViewController.view.makeToast("번호인증을 완료한 기록이 있습니다. 세부 정보를 입력해주세요.")
        }
        
        window?.rootViewController = entryViewController
        window?.makeKeyAndVisible()
    }
}
