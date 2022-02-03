//
//  SettingMyInfoViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/03.
//

import UIKit
import RxSwift
import RxCocoa

class SettingMyInfoViewModel: ViewModel, ViewModelType {
    
    let gender = BehaviorRelay<Gender>(value: .unknown)
    let hobby = BehaviorRelay<String>(value: "")
    let searchable = BehaviorRelay<Bool>(value: false)
    let ageRange = BehaviorRelay<[CGFloat]>(value: [18, 35])
    
    struct Input {
        let womanOptionButtonTap: Driver<Void>
        let manOptionButtonTap: Driver<Void>
        let rangeValues: Driver<[CGFloat]>
    }
    struct Output {
        let gender: Driver<Gender>
        let ageLabelText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        input.womanOptionButtonTap.debug()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.woman)
            }
            .disposed(by: disposeBag)
        
        input.manOptionButtonTap.debug()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.gender.accept(.man)
            }
            .disposed(by: disposeBag)
        
        let ageLabelText = ageRange.asDriver()
            .map { value in
                "\(Int(value[0])) - \(Int(value[1]))"
            }
        
        return Output(
            gender: gender.asDriver(),
            ageLabelText: ageLabelText
        )
    }
}
