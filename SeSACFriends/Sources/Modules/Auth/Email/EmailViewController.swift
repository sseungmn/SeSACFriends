//
//  EmailViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit
import RxCocoa
import RxSwift

class EmailViewController: ViewController {
    
    let mainView = EmailView()
    let viewModel = EmailViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.emailTextField.becomeFirstResponder()
    }
    
    override func bind() {
        let input = EmailViewModel.Input(
            confirmButtonTap: self.mainView.button.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.emailTextField.rx.textInput <-> viewModel.email
        
        output.buttonState
            .drive(self.mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        
        output.pushGenderViewController
            .drive(onNext: { [weak self] _ in
                self?.push(viewController: GenderViewController())
            })
            .disposed(by: disposeBag)
            
        viewModel.errorCollector
            .subscribe(onNext: { [weak self] error in
                guard let error = error as? EmailError else { return }
                switch error {
                case .invalidEmail:
                    self?.mainView.emailTextField.resignFirstResponder()
                    self?.view.makeToast("이메일 형식이 올바르지 않습니다.")
                }
            })
            .disposed(by: disposeBag)
    }
}
