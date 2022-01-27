//
//  ViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneNumberViewController: BaseViewController {
    
    let mainView = PhoneNumberView()
    let viewModel = PhoneNumberViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.phoneNumberTextField.becomeFirstResponder()
    }
    
    override func bind() {
        let input = PhoneNumberViewModel.Input(
            submitButtonTap: mainView.button.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.phoneNumberTextField.rx.textInput <-> viewModel.phoneNumber
        
        output.outputText
            .bind(to: mainView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.buttonState
            .bind(to: mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        
        output.verifyResult
            .subscribe(onNext: { [weak self] verificationID in
                debug(title: "verificationID", verificationID)
                AuthUserDefaults.verificaitonID = verificationID
                self?.push(viewController: AuthCodeViewController())
            })
            .disposed(by: disposeBag)
    }
}
