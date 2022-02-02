//
//  EditableInfoCells.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import RxSwift
import RxCocoa

enum Gender: Int {
    case unknown = -1
    case woman = 0
    case man = 1
}

final class SettingGenderComponent: ReactiveView {
    let gender = BehaviorRelay<Gender>(value: .unknown)
    
    let titleLabel = UILabel().then { label in
        label.font = .Title4_R14
        label.textColor = Asset.Colors.black.color
        label.text = "내 성별"
    }
    
    let manOptionButton = StateButton().then { button in
        button.setStyleState(styleState: .inactive)
        button.setTitle("남자", for: .normal)
    }
    
    let womanOptionButton = StateButton().then { button in
        button.setStyleState(styleState: .inactive)
        button.setTitle("여자", for: .normal)
    }
    
    override func setConstraint() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        addSubview(womanOptionButton)
        womanOptionButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        addSubview(manOptionButton)
        manOptionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(womanOptionButton.snp.leading).offset(-8)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        
        womanOptionButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.woman)
            }
            .disposed(by: disposeBag)
        
        manOptionButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.man)
            }
            .disposed(by: disposeBag)
        
        gender.debug()
            .bind { [weak self] gender in
                guard let self = self else { return }
                if gender == .man {
                    self.manOptionButton.setStyleState(styleState: .fill)
                    self.womanOptionButton.setStyleState(styleState: .inactive)
                } else if gender == .woman {
                    self.manOptionButton.setStyleState(styleState: .inactive)
                    self.womanOptionButton.setStyleState(styleState: .fill)
                } else {
                    self.manOptionButton.setStyleState(styleState: .inactive)
                    self.womanOptionButton.setStyleState(styleState: .inactive)
                }
            }
            .disposed(by: disposeBag)
    }
}
