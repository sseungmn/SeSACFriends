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
        hidesBottomBarWhenPushed = true
    }
}

extension MainViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let firstTabBarItem = HomeViewController()
        firstTabBarItem.tabBarItem.image = Asset.Assets.homeInact.image
        firstTabBarItem.tabBarItem.selectedImage = Asset.Assets.homeAct.image
        firstTabBarItem.tabBarItem.title = "홈"
        
        let secondTabBarItem = SesacShopViewController()
        secondTabBarItem.tabBarItem.image = Asset.Assets.shopInact.image
        secondTabBarItem.tabBarItem.selectedImage = Asset.Assets.shopAct.image
        secondTabBarItem.tabBarItem.title = "새싹샵"
        
        let thirdTabBarItem = MyInfoViewController()
        thirdTabBarItem.tabBarItem.image = Asset.Assets.myInact.image
        thirdTabBarItem.tabBarItem.selectedImage = Asset.Assets.myAct.image
        thirdTabBarItem.tabBarItem.title = "내 정보"
        
        let viewControllers = [firstTabBarItem, secondTabBarItem, thirdTabBarItem]
        self.setViewControllers(viewControllers, animated: true)
    }
}
