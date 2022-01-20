//
//  PhoneNumberView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/20.
//

import UIKit

class AuthCodeView: AuthBaseView {
    let authCodeStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
    }
    let timerLabel = UILabel().then { label in
        label.textColor = Asset.Colors.brandGreen.color
        label.font = .Title3_M14
    }
    let authCodeTextField = StateTextField().then { textField in
        textField.setStyleState(styleState: .normal)
        textField.keyboardType = .numberPad
    }
    let resendButton = StateButton(initialStyleState: .fill).then { button in
        button.snp.makeConstraints { make in
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
    }
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "인증번호가 문자로 전송되었어요")
        setDescriptionSubtitle(subtitle: "(최대 소모 20초)")
        authCodeTextField.setPlaceholder(placeholder: "인증번호 입력")
        resendButton.setTitle("재전송", for: .normal)
        setButtonTitle(title: "인증하고 시작하기")
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        authCodeTextField.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.right.equalToSuperview().inset(12)
        }
        addUserInputComponent(component: authCodeStackView)
        authCodeStackView.addArrangedSubview(authCodeTextField)
        authCodeStackView.addArrangedSubview(resendButton)
    }
}
