//
//  AuthCodeViewController.swift
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

class AuthCodeViewController: UIViewController {

    let disposeBag = DisposeBag()
    let authCode = PublishRelay<String>()

    let mainView = AuthCodeView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
    }

    func bind() {
        mainView.authCodeTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: authCode)
            .disposed(by: disposeBag)

        mainView.button.rx.tap
            .withLatestFrom(authCode.asObservable())
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
