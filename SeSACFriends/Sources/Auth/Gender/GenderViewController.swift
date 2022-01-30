//
//  GenderViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit

import RxCocoa
import RxSwift

class GenderViewController: BaseViewController {
    
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
                self?.makeRoot(viewController: MainViewController())
            }
            .disposed(by: disposeBag)
        
        output.alreadyUser
            .drive { [weak self] _ in
                self?.view.makeToast("이미 가입한 회원입니다.")
            }
            .disposed(by: disposeBag)
            
        output.invalidNickname
            .drive { [weak self] _ in
                self?.navigationController?.popToViewController(NicknameViewController(), animated: false)
            }
            .disposed(by: disposeBag)
    }
}
