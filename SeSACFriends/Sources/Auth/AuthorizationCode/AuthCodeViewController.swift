//
//  AuthCodeViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

import RxCocoa
import RxSwift
import Toast_Swift

class AuthCodeViewController: BaseViewController {
    
    let mainView = AuthCodeView()
    let viewModel = AuthCodeViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.makeToast("인증번호를 보냈습니다.", duration: 3)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func configure() {
        mainView.authCodeTextField.textContentType = .oneTimeCode
    }

    override func bind() {
        let input = AuthCodeViewModel.Input(
            inputText: mainView.authCodeTextField.rx.text.orEmpty.debug("inputText"),
            resendButtonTap: mainView.resendButton.rx.tap.debug("resendButtonTap"),
            submitButtonTap: mainView.button.rx.tap.share(replay: 1).debug("submitButtonTap"),
            viewWillDisappear: self.rx.viewWillDisappear.debug("viewWillDisappear")
        )
        
        let output = viewModel.transform(input: input)
        
        output.error
            .subscribe { authError in
                self.mainView.authCodeTextField.resignFirstResponder()
                guard let authError = authError.element else { return }
                debug(title: "authError", authError)
                switch authError {
                case .authCodeExpired:
                    self.view.makeToast("전화 번호 인증 실패")
                case .invalidCode:
                    self.view.makeToast("전화 번호 인증 실패")
                case .idtokenError:
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요")
                }
            }
            .disposed(by: disposeBag)
        
        output.remainTime
            .map { time in
                String(format: "%02d:%02d", time / 60, time % 60)
            }
            .bind(to: mainView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.buttonState
            .bind(to: mainView.button.rx.styleState)
            .disposed(by: disposeBag)

        output.isUser
            .subscribe(onNext: { isUser in
                switch isUser {
                case true:
                    self.makeRoot(viewController: MainViewController())
                case false:
                    self.push(viewController: NicknameViewController())
                }
            })
            .disposed(by: disposeBag)
    }

}
