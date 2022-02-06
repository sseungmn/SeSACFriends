//
//  MainViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tabBar.backgroundColor = .clear
        tabBar.tintColor = Asset.Colors.brandGreen.color
        tabBar.unselectedItemTintColor = Asset.Colors.gray6.color
        tabBar.isHidden = false
        hidesBottomBarWhenPushed = false
    }
}

extension MainViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let firstTabBarItem = HomeViewController()
        let nav1 = UINavigationController(rootViewController: firstTabBarItem)
        firstTabBarItem.tabBarItem.image = Asset.Assets.homeInact.image
        firstTabBarItem.tabBarItem.selectedImage = Asset.Assets.homeAct.image
        firstTabBarItem.tabBarItem.title = "홈"
        
        let secondTabBarItem = SesacShopViewController()
        let nav2 = UINavigationController(rootViewController: secondTabBarItem)
        secondTabBarItem.tabBarItem.image = Asset.Assets.shopInact.image
        secondTabBarItem.tabBarItem.selectedImage = Asset.Assets.shopAct.image
        secondTabBarItem.tabBarItem.title = "새싹샵"
        
        let thirdTabBarItem = MyInfoViewController()
        let nav3 = UINavigationController(rootViewController: thirdTabBarItem)
        thirdTabBarItem.tabBarItem.image = Asset.Assets.myInact.image
        thirdTabBarItem.tabBarItem.selectedImage = Asset.Assets.myAct.image
        thirdTabBarItem.tabBarItem.title = "내 정보"
        
        let viewControllers = [nav1, nav2, nav3]
        self.setViewControllers(viewControllers, animated: true)
    }
}
