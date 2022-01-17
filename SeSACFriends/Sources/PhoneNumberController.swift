//
//  ViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

class PhoneNumberController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let phoneNumberTextField = UITextField().then { textField in
        textField.placeholder = "휴대폰 번호 숫자만 입력"
        textField.keyboardType = .numberPad
    }
    let phoneNumber = PublishRelay<String>()
    
    let confirmButton = UIButton().then { button in
        var config = UIButton.Configuration.filled()
        config.title = "인증 번호 받기"
        config.baseBackgroundColor = .systemGreen
        button.configuration = config
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConstraint()
        bind()
    }
    
    func setConstraint() {
        view.addSubview(phoneNumberTextField)
        view.addSubview(confirmButton)
        phoneNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
        
    func bind() {
        phoneNumberTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: phoneNumber)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .withLatestFrom(phoneNumber.asObservable())
            .flatMap(verifyPhoneNumber)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] verificationID in
                    print("DEBUG || verificationID :", verificationID)
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self?.navigationController?.pushViewController(VerificationViewController(), animated: true)
                },
                onError: { error in
                    print("ERROR", error)
                })
            .disposed(by: disposeBag)
    }
    
    func verifyPhoneNumber(phoneNumber: String) -> Observable<String> {
        print("DEBUG || phoneNumber :", phoneNumber)
        return Observable<String>.create { observer in
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    guard let verificationID = verificationID else {
                        observer.onError(AnError.fail)
                        return
                    }
                    observer.onNext(verificationID)
                }
            return Disposables.create()
        }
    }
}

enum AnError: Error {
    case fail
}
