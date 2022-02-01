//
//  NickenameView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

class NicknameView: AuthView {
    let nicknameTextField = StateTextField()
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "닉네임을 입력해 주세요")
        addUserInputComponent(component: nicknameTextField)
        nicknameTextField.setPlaceholder(placeholder: "10자 이내로 입력")
        setButtonTitle(title: "다음")
    }
}
