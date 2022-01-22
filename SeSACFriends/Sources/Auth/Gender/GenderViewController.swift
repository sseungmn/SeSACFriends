//
//  GenderViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

class GenderViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let gender = BehaviorRelay<Int>(value: 2)
    
    let mainView = GenderView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        
    }
}
