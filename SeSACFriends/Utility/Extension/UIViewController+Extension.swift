//
//  UIViewController+Extension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

extension UIViewController {
    func makeRoot(viewController: UIViewController, withNavigationController: Bool = true) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        var rootViewController: UIViewController
        if withNavigationController {
            rootViewController = UINavigationController(rootViewController: viewController)
        } else {
            rootViewController = viewController
        }
        windowScene.windows.first?.rootViewController = rootViewController
        windowScene.windows.first?.makeKeyAndVisible()
    }
    
    func push(viewController: UIViewController) {
        navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop<T: ViewController>(to viewController: T, completion: ((T) -> Void)? = nil) {
        guard let navigationStack = self.navigationController?.viewControllers else { return }
        for viewController in navigationStack {
            if let targetViewController = viewController as? T {
                completion?(targetViewController)
                self.navigationController?.popToViewController(targetViewController, animated: false)
            }
        }
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: false)
    }
}
