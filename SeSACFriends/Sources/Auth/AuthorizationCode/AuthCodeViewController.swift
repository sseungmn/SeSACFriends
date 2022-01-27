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

    override func configure() {
        mainView.authCodeTextField.textContentType = .oneTimeCode
    }

    override func bind() {
        let input = AuthCodeViewModel.Input(
            resendButtonTap: mainView.resendButton.rx.tap.debug("resendButtonTap"),
            submitButtonTap: mainView.button.rx.tap.share(replay: 1).debug("submitButtonTap"),
            viewDidLoad: self.rx.viewDidLoad.debug("viewDidLoad")
        )
        
        let output = viewModel.transform(input: input)
        
        mainView.authCodeTextField.rx.textInput <-> viewModel.authCode
        
        viewModel.error
            .subscribe(onNext: { error in
                self.mainView.authCodeTextField.resignFirstResponder()
                debug(title: "error", error)
                guard let authError = error as? AuthCodeError else { return }
                switch authError {
                case .authCodeExpired:
                    self.view.makeToast("전화 번호 인증 실패")
                case .invalidCode:
                    self.view.makeToast("전화 번호 인증 실패")
                case .idtokenError:
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요")
                }
            })
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

        output.makeRootMainViewController
            .subscribe(onNext: {
                    self.makeRoot(viewController: MainViewController())
            })
            .disposed(by: disposeBag)
        
        output.pushNicknameViewControoler
            .subscribe(onNext: {
                    self.push(viewController: NicknameViewController())
            })
            .disposed(by: disposeBag)
        
        output.sentAuthCode
            .subscribe(onNext: { _ in
                self.view.makeToast("인증번호를 보냈습니다.")
            })
            .disposed(by: disposeBag)
    }

}
