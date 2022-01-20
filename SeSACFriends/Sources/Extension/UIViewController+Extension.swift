//
//  UIViewController+Extension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

extension UIViewController {
    func makeRoot(viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: viewController)
        windowScene.windows.first?.makeKeyAndVisible()
    }
    
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
