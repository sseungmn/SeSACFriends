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
    
    struct Input {
        let womanOptionButtonTap: Driver<Void>
        let manOptionButtonTap: Driver<Void>
    }
    struct Output {
        let gender: Driver<Gender>
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
        
        return Output(
            gender: gender.asDriver()
        )
    }
}
