//
//  GenderViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import UIKit

import RxSwift
import RxCocoa

class GenderViewModel: ViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let man = BehaviorRelay<Bool>(value: false)
    let woman = BehaviorRelay<Bool>(value: false)
    let gender = BehaviorRelay<Int>(value: -1)
    
    struct Input {
        let manButtonTap: Driver<Void>
        let womanButtonTap: Driver<Void>
        let confirmButtonTap: Driver<Void>
    }
    
    struct Output {
        let manButtonState: Driver<ButtonStyleState>
        let womanButtonState: Driver<ButtonStyleState>
        let confirmButtonState: Driver<ButtonStyleState>
    }
    
    func transform(input: Input) -> Output {
        input.manButtonTap
            .map { _ in
                if !self.man.value && self.woman.value {
                    self.woman.accept(false)
                }
                return !self.man.value
            }
            .drive(man)
            .disposed(by: disposeBag)
        
        input.womanButtonTap
            .map { _ in
                if self.man.value && !self.woman.value {
                    self.man.accept(false)
                }
                return !self.woman.value
            }
            .drive(woman)
            .disposed(by: disposeBag)
        
        let manButtonState: Driver<ButtonStyleState> = man
            .asDriver()
            .debug("man")
            .map { $0 ? ButtonStyleState.fill : ButtonStyleState.inactive }
        
        let womanButtonState: Driver<ButtonStyleState> = woman
            .asDriver()
            .debug("woman")
            .map { $0 ? ButtonStyleState.fill : ButtonStyleState.inactive }
        
        let confirmButtonState: Driver<ButtonStyleState> = Driver
            .combineLatest(man.asDriver(), woman.asDriver()) { man, woman in
                man || woman
            }
            .map { $0 ? ButtonStyleState.fill : ButtonStyleState.disable }
        
        Driver.combineLatest(man.asDriver(), woman.asDriver()) { man, woman in
            if woman { return 1 }
            else if man { return 2 }
            else { return -1 }
        }
        .drive(gender)
        .disposed(by: disposeBag)
        
        return Output(
            manButtonState: manButtonState,
            womanButtonState: womanButtonState,
            confirmButtonState: confirmButtonState
        )
    }
}
