//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit

class HobbyViewController: ViewController {
    
    let mainView = HobbyView()
    
    override func loadView() {
        view = mainView
    }
}
