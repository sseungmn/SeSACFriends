//
//  MainViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit
import SnapKit

import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    let button = StateButton().then { button in
        button.setTitle("버튼", for: .normal)
    }
    
    let iconButton = IconStateButton()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(iconButton)
        iconButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let list = ["코딩", "클라이밍", "달리기", "오일파스텔", "엄청나게긴취미"]
        let isIconHidden = [false, true]
        iconButton.rx.tap
            .subscribe { _ in
                let hobby = list.randomElement()!
                let isHidden = isIconHidden.randomElement()!
                self.iconButton.setTitle(title: hobby)
                self.iconButton.setIconHidden(isHidden: isHidden)
            }
//        view.addSubview(button)
        
//        button.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(300)
//            make.height.equalTo(48)
//        }
//
//        let list: [ButtonStyleState] = [.inactive,.fill,.outline,.disable,.cancel]
//
//        button.rx.tap
//            .subscribe { _ in
//                let state = list.randomElement()!
//                self.button.styleState.accept(state)
//                self.button.setTitle(state.rawValue
//                                     , for: .normal)
//            }
//            .disposed(by: disposeBag)

    }
}
