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

class PhoneNumberViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let phoneNumber = PublishRelay<String>()
    
    let mainView = PhoneNumberView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        mainView.phoneNumberTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: phoneNumber)
            .disposed(by: disposeBag)
        // Validation Required
        mainView.phoneNumberTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { text in
                [10, 11].contains(text.count) ? ButtonStyleState.fill : ButtonStyleState.disable
            }
            .bind(to: mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        mainView.button.rx.tap
            .withLatestFrom(phoneNumber.asObservable())
            .flatMap(verifyPhoneNumber)
            .observe(on: MainScheduler.instance)
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
