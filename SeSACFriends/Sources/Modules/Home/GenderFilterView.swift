//
//  GenderFilterView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import UIKit
import RxSwift
import RxCocoa

class GenderFilterView: ReactiveView {
    
    let filteredGender = BehaviorRelay<Gender>(value: .unknown)
    
    let stackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = true
    }
    
    let allOptionButton = StateButton().then { button in
        button.setStyleState(styleState: .fill)
        button.layer.cornerRadius = 0
        button.setTitle("전체", for: .normal)
    }
    
    let manOptionButton = StateButton().then { button in
        button.setStyleState(styleState: .inactive)
        button.layer.cornerRadius = 0
        button.setTitle("남자", for: .normal)
    }
    
    let womanOptionButton = StateButton().then { button in
        button.setStyleState(styleState: .inactive)
        button.layer.cornerRadius = 0
        button.setTitle("여자", for: .normal)
    }
    
    override func bind() {
        Observable.merge(
            allOptionButton.rx.tap.map { _ in Gender.unknown },
            manOptionButton.rx.tap.map { _ in Gender.man },
            womanOptionButton.rx.tap.map { _ in Gender.woman }
        ).debug()
            .bind(to: filteredGender)
            .disposed(by: disposeBag)
        
        filteredGender
            .subscribe(onNext: { [weak self] filteredGender in
                guard let self = self else { return }
                switch filteredGender {
                case .unknown:
                    self.allOptionButton.setStyleState(styleState: .fill)
                    self.manOptionButton.setStyleState(styleState: .inactive)
                    self.womanOptionButton.setStyleState(styleState: .inactive)
                case .man:
                    self.allOptionButton.setStyleState(styleState: .inactive)
                    self.manOptionButton.setStyleState(styleState: .fill)
                    self.womanOptionButton.setStyleState(styleState: .inactive)
                case .woman:
                    self.allOptionButton.setStyleState(styleState: .inactive)
                    self.manOptionButton.setStyleState(styleState: .inactive)
                    self.womanOptionButton.setStyleState(styleState: .fill)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        layer.cornerRadius = 8
        bounds = CGRect(x: 0, y: 0, width: 48, height: 144)
        self.setShadow()
    }
    
    override func setConstraint() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.addArrangedSubview(allOptionButton)
        stackView.addArrangedSubview(manOptionButton)
        stackView.addArrangedSubview(womanOptionButton)
        allOptionButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        manOptionButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        womanOptionButton.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
}
