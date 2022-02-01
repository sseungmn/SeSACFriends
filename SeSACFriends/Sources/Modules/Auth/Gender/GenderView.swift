//
//  GenderView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/22.
//

import UIKit

final class GenderButton: StateButton {
    let iconImageView = UIImageView()
    let label = UILabel()
    
    override func configure() {
        super.configure()
        setStyleState(styleState: .inactive)
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        addSubview(iconImageView)
        addSubview(label)
        self.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
        }
    }
}

class GenderView: AuthView {
    let manButton = GenderButton().then { button in
        button.iconImageView.image = Asset.Assets.man.image
        button.label.text = "남자"
    }
    let womanButton = GenderButton().then { button in
        button.iconImageView.image = Asset.Assets.woman.image
        button.label.text = "여자"
    }
    let genderButtonStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.alignment = .center
    }
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "성별을 선택해 주세요")
        setDescriptionSubtitle(subtitle: "새싹 찾기 기능을 이용하기 위해서 필요해요!")
        genderButtonStackView.addArrangedSubview(manButton)
        setButtonTitle(title: "다음")
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        addUserInputComponent(component: genderButtonStackView)
        genderButtonStackView.addArrangedSubview(womanButton)
    }
}
