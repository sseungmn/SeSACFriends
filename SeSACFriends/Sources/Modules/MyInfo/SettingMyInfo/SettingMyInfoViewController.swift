//
//  SettingMyInfoViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import RxSwift
import RxCocoa

class SettingMyInfoViewController: ViewController {
    
    let mainView = SettingMyInfoView()
    let viewModel = SettingMyInfoViewModel()
    let saveButton = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil).then { button in
        button.tintColor = Asset.Colors.black.color
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func bind() {
        let input = SettingMyInfoViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            saveButtonTap: saveButton.rx.tap.asDriver(),
            womanOptionButtonTap: mainView.genderComponent.womanOptionButton.rx.tap.asDriver(),
            manOptionButtonTap: mainView.genderComponent.manOptionButton.rx.tap.asDriver(),
            withdrawButtonTap: mainView.withdrawButton.rx.tap.asDriver(),
            rangeValues: mainView.ageGroupComponent.rangeSlider.rx.value.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        mainView.hobbyComponent.textField.rx.textInput <-> viewModel.hobby
        mainView.searchableComponent.`switch`.rx.isOn <-> viewModel.searchable
        mainView.ageGroupComponent.rangeSlider.rx.value <-> viewModel.ageRange
        
        output.gender
            .drive(onNext: { [weak self] gender in
                guard let manButton = self?.mainView.genderComponent.manOptionButton,
                      let womanButton = self?.mainView.genderComponent.womanOptionButton else { return }
                switch gender {
                case .unknown:
                    manButton.setStyleState(styleState: .inactive)
                    womanButton.setStyleState(styleState: .inactive)
                case .woman:
                    manButton.setStyleState(styleState: .inactive)
                    womanButton.setStyleState(styleState: .fill)
                case .man:
                    manButton.setStyleState(styleState: .fill)
                    womanButton.setStyleState(styleState: .inactive)
                }
            })
            .disposed(by: disposeBag)
        
        output.ageLabelText
            .drive(mainView.ageGroupComponent.rangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.withdrawCompleted
            .drive(onNext: { [weak self] in
                AuthUserDefaults.clearAuthParams()
                self?.makeRoot(viewController: OnboardingViewController())
            })
            .disposed(by: disposeBag)
        
        output.saveCompleted
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
}
