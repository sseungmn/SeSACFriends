//
//  EmailViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit

import RxCocoa
import RxSwift

class EmailViewController: BaseViewController {
    
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
            inputText: self.mainView.emailTextField.rx.text.orEmpty.asDriver().debug("inputText"),
            confirmButtonTap: self.mainView.button.rx.tap.asDriver().debug("confirmButtonTap")
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonState
            .drive(self.mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        output.confirmButtonTap
            .asObservable()
            .subscribe { [unowned self] isValid in
                guard let isValid = isValid.element else { return }
                if isValid { self.push(viewController: GenderViewController() )}
            }
            .disposed(by: disposeBag)

        output.error.asObservable()
            .subscribe { [unowned self] error in
                guard let error = error.element else { return }
                switch error {
                case .invalidEmail:
                    self.mainView.emailTextField.resignFirstResponder()
                    self.view.makeToast("이메일 형식이 올바르지 않습니다.")
                }
            }
            .disposed(by: disposeBag)
    }
}
