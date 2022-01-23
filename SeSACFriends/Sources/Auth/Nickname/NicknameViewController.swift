//
//  NicknameViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

import RxCocoa
import RxSwift
import Toast_Swift

class NicknameViewController: BaseViewController {
    
    let mainView = NicknameView()
    let viewModel = NicknameViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.nicknameTextField.becomeFirstResponder()
    }
    
    override func bind() {
        let input = NicknameViewModel.Input(
            inputText: mainView.nicknameTextField.rx.text.orEmpty.debug("inputText"),
            submitButtonTap: mainView.button.rx.tap.debug("submitButtonTap")
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonState
            .bind(to: mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        
        output.isValidNickname
            .subscribe { isValid in
                guard let isValid = isValid.element else { return }
                switch isValid {
                case true:
                    self.push(viewController: BirthViewController())
                case false:
                    self.mainView.nicknameTextField.resignFirstResponder()
                    self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.")
                }
            }
            .disposed(by: disposeBag)
    }
}
