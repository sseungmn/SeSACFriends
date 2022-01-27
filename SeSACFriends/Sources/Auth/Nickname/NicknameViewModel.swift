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
        let submitButtonTap: Observable<Void>
    }
    
    struct Output {
        let buttonState: Observable<ButtonStyleState>
        let validNickname: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let validation = nick
            .map(validation)
            .share()
                
        let buttonState: Observable<ButtonStyleState> = validation
            .map { $0 ? .fill : .disable }
        
        let validNickname = input.submitButtonTap
            .withLatestFrom(validation)
            .share()
        
        validNickname
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                AuthUserDefaults.nick = self.nick.value
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
