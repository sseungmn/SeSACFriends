//
//  EmailView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit

class EmailView: AuthBaseView {
    let emailTextField = StateTextField().then { textField in
        textField.setPlaceholder(placeholder: "SeSAC@email.com")
    }
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "이메일을 입력해 주세요")
        setDescriptionSubtitle(subtitle: "휴대폰 번호 변경 시 인증을 위해 사용해요")
        addUserInputComponent(component: emailTextField)
        setButtonTitle(title: "다음")
        
//        emailTextField.becomeFirstResponder()
    }
}
