//
//  ViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class PhoneNumberViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let phoneNumber = PublishRelay<String>()
    
    let mainView = PhoneNumberView()
    let viewModel = PhoneNumberViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.phoneNumberTextField.becomeFirstResponder()
    }
    
    func bind() {
        let input = PhoneNumberViewModel.Input(
            inputText: mainView.phoneNumberTextField.rx.text.orEmpty.share(replay: 1),
            buttonTap: mainView.button.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.outputText
            .bind(to: mainView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.buttonState
            .bind(to: mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        
        output.verifyResult
            .subscribe(
                onNext: { [weak self] verificationID in
                    print("DEBUG || verificationID :", verificationID)
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self?.push(viewController: AuthCodeViewController())
                },
                onError: { error in
                    print("ERROR", error)
                })
            .disposed(by: disposeBag)
    }
}
