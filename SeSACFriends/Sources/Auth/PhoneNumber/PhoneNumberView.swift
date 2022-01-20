//
//  PhoneNumberView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/20.
//

import UIKit

class PhoneNumberView: AuthBaseView {
    let phoneNumberTextField = StateTextFeild()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요")
        addUserInputComponent(component: phoneNumberTextField)
        phoneNumberTextField.setStyleState(styleState: .normal)
        phoneNumberTextField.setPlaceholder(placeholder: "휴대폰 번호(-없이 숫자만 입력)")
        phoneNumberTextField.keyboardType = .numberPad
        setButtonTitle(title: "인증 문자 받기")
    }
}
