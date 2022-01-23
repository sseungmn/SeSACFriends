//
//  NicknameViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

import RxSwift
import RxCocoa

class NicknameViewModel: ViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let nickname = PublishRelay<String>()
    
    let error = PublishRelay<NicknameError>()
    
    struct Input {
        let inputText: Observable<String>
        let submitButtonTap: Observable<Void>
    }
    
    struct Output {
        let buttonState: Observable<ButtonStyleState>
        let isValidNickname: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        input.inputText
            .bind(to: nickname)
            .disposed(by: disposeBag)
        
        let isValid = nickname
            .map(validation)
        
        let buttonState: Observable<ButtonStyleState> = isValid
            .map { $0 ? .fill : .disable }
        
        let isValidNickname = input.submitButtonTap
            .withLatestFrom(isValid)
        
        return Output(
            buttonState: buttonState,
            isValidNickname: isValidNickname
        )
    }
    
    func validation(nickname: String) -> Bool {
        return 1...10 ~= nickname.count
    }
}

enum NicknameError: Error {
    case invalidNickname, forbiddenNickname
}
