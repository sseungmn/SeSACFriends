//
//  NicknameViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel: ViewModel, ViewModelType {
    
    let nick = BehaviorRelay<String>(value: AuthUserDefaults.nick)
    
    struct Input {
        let submitButtonTap: Driver<Void>
    }
    
    struct Output {
        let buttonState: Driver<ButtonStyleState>
        let validNickname: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validation = nick
            .map(validation)
            .asDriver(onErrorJustReturn: false)
                
        let buttonState: Driver<ButtonStyleState> = validation
            .map { $0 ? .fill : .disable }
            .asDriver(onErrorJustReturn: .disable)
        
        let validNickname: Driver<Bool> = input.submitButtonTap
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                AuthUserDefaults.nick = self.nick.value
            })
            .withLatestFrom(validation)
            .asDriver(onErrorJustReturn: false)
        
        validNickname
            .filter { !$0 }
            .drive(onNext: {  _ in
                AuthUserDefaults.nick = ""
            })
            .disposed(by: disposeBag)
        
        return Output(
            buttonState: buttonState,
            validNickname: validNickname
        )
    }
    
    func validation(nickname: String) -> Bool {
        return 1...10 ~= nickname.count
    }
}

enum NicknameError: Error {
    case invalidNickname, forbiddenNickname
}
