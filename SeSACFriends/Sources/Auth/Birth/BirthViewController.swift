//
//  BirthViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

import RxCocoa
import RxSwift

class BirthViewController: BaseViewController {
    
    let mainView = BirthView()
    let viewModel = BirthViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        mainView.yearComponentView.textField.becomeFirstResponder()
        mainView.datePicker.date = Date.now
    }
    
    override func bind() {
        let input = BirthViewModel.Input(
            inputDate: self.mainView.datePicker.rx.date.share(replay: 1).debug("inputDate"),
            submitButtonTap: self.mainView.button.rx.tap.debug("submitButotnTap")
        )
        let output = viewModel.transform(input: input)
        
        output.yearString
            .drive(self.mainView.yearComponentView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.yearFocus
            .drive(self.mainView.yearComponentView.textField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        output.monthString
            .drive(self.mainView.monthComponentView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.monthFocus
            .drive(self.mainView.monthComponentView.textField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        output.dayString
            .drive(self.mainView.dayComponentView.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.dayFocus
            .drive(self.mainView.dayComponentView.textField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        output.submitButtonTap
            .emit { [weak self] _ in
                self?.push(viewController: EmailViewController())
            }
            .disposed(by: disposeBag)
        
        output.buttonState
            .drive(self.mainView.button.rx.styleState)
            .disposed(by: disposeBag)
    }
}
