//
//  ViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneNumberViewController: ViewController {
    
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
            submitButtonTap: mainView.button.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.phoneNumberTextField.rx.textInput <-> viewModel.phoneNumber
        
        output.outputText
            .drive(mainView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.buttonState
            .drive(mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        
        output.verifyResult
            .drive(onNext: { [weak self] verificationID in
                debug(title: "verificationID", verificationID)
                AuthUserDefaults.verificaitonID = verificationID
                self?.push(viewController: AuthCodeViewController())
            })
            .disposed(by: disposeBag)
    }
}
