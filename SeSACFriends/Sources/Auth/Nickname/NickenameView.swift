//
//  NickenameView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

class NicknameView: AuthBaseView {
    let nicknameTextField = StateTextField()
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "닉네임을 입력해 주세요")
        addUserInputComponent(component: nicknameTextField)
        nicknameTextField.setPlaceholder(placeholder: "10자 이내로 입력")
        nicknameTextField.setStyleState(styleState: .normal)
        setButtonTitle(title: "다음")
    }
}
