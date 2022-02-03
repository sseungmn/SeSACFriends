//
//  SettingHobbyComponent.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/03.
//

import UIKit

class SettingHobbyComponent: View {
    let titleLabel = UILabel().then { label in
        label.font = .Title4_R14
        label.textColor = Asset.Colors.black.color
        label.text = "자주 하는 취미"
    }
    
    let textField = StateTextField().then { textField in
        textField.setPlaceholder(placeholder: "취미를 입력해 주세요")
    }
    
    override func setConstraint() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.width.equalTo(164)
        }
    }
}
