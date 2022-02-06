//
//  GenderViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit

import RxCocoa
import RxSwift

class GenderViewController: ViewController {
    
    let mainView = GenderView()
    let viewModel = GenderViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func bind() {
        let input = GenderViewModel.Input(
            manButtonTap: self.mainView.manButton.rx.tap.asDriver(),
            womanButtonTap: self.mainView.womanButton.rx.tap.asDriver(),
            confirmButtonTap: self.mainView.button.rx.tap.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.manButtonState
            .drive(self.mainView.manButton.rx.styleState)
            .disposed(by: disposeBag)
        
        output.womanButtonState
            .drive(self.mainView.womanButton.rx.styleState)
            .disposed(by: disposeBag)
        
        output.confirmButtonState
            .drive(self.mainView.button.rx.styleState)
            .disposed(by: disposeBag)
        
        output.makeRootMainViewController
            .drive { [weak self] _ in
                AuthUserDefaults.isUser = true
                self?.makeRoot(viewController: MainViewController(), withNavigationController: false)
            }
            .disposed(by: disposeBag)
        
        output.alreadyUser
            .drive { [weak self] _ in
                self?.view.makeToast("이미 가입한 회원입니다.")
            }
            .disposed(by: disposeBag)
            
        output.invalidNickname
            .drive { [weak self] _ in
                self?.pop(to: NicknameViewController()) { nicknameViewController in
                    nicknameViewController.view.makeToast("올바른 닉네임을 입력하세요")
                }
            }
            .disposed(by: disposeBag)
    }
}
