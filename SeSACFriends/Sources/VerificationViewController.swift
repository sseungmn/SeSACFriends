//
//  VerificationViewController.swift
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

class VerificationViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    let verificationNumberTextField = UITextField().then { textField in
        textField.placeholder = "인증번호 입력"
        textField.keyboardType = .numberPad
    }
    let verficationNumber = PublishRelay<String>()
    
    let confirmButton = UIButton().then { button in
        var config = UIButton.Configuration.filled()
        config.title = "인증하고 시작하기"
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
        view.addSubview(verificationNumberTextField)
        view.addSubview(confirmButton)
        verificationNumberTextField.snp.makeConstraints { make in
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
        verificationNumberTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: verficationNumber)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .withLatestFrom(verficationNumber.asObservable())
            .flatMap(credential)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: MainViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                },
                onError: { error in
                    print("ERROR", error)
                })
            .disposed(by: disposeBag)
    }
    
    func credential(verificationCode: String) -> Observable<Void> {
        return Observable.create { observer in
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode
            )
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
