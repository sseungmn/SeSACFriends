//
//  NicknameViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

class NicknameViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let nickname = PublishRelay<String>()
    
    let mainView = NicknameView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        mainView.nicknameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: nickname)
            .disposed(by: disposeBag)
        nickname
            .map { $0.count <= 10 ? ButtonStyleState.fill : ButtonStyleState.disable }
            .bind(to: mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        mainView.button.rx.tap
            .subscribe { [weak self] _ in
//                self?.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
