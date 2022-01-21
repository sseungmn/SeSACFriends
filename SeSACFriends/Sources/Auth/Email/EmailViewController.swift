//
//  EmailViewController.swift
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

class EmailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let email = PublishRelay<String>()
    
    let mainView = EmailView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.emailTextField.becomeFirstResponder()
    }
    
    func bind() {
        mainView.emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: email)
            .disposed(by: disposeBag)
        mainView.button.rx.tap
            .subscribe { [weak self] _ in
//                self?.push(viewController: <#T##UIViewController#>)
            }
            .disposed(by: disposeBag)
    }
}
