//
//  SettingMyInfoView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import SnapKit

class SettingMyInfoView: View {
    let scrollView = UIScrollView().then { scrollView in
        scrollView.bounces = false
        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    let userCardView = UserCardView()
    let genderComponent = SettingGenderComponent()
    let hobbyComponent = SettingHobbyComponent()
    let searchableComponent = SettingSearchableComponent()
    let ageGroupComponent = SettingAgeGroupComponent()
    let withdrawButton = UIButton().then { button in
        let titleLabel = UILabel().then { label in
            label.font = .Title4_R14
            label.textColor = Asset.Colors.black.color
            label.text = "회원탈퇴"
        }
        button.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
    }
    
    let settingsContainer = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
    }
    
    override func setConstraint() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        scrollView.addSubview(userCardView)
        userCardView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalToSuperview().offset(-32)
        }
        scrollView.addSubview(settingsContainer)
        settingsContainer.snp.makeConstraints { make in
            make.top.equalTo(userCardView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
        }
        
        settingsContainer.addArrangedSubview(genderComponent)
        settingsContainer.addArrangedSubview(hobbyComponent)
        settingsContainer.addArrangedSubview(searchableComponent)
        settingsContainer.addArrangedSubview(ageGroupComponent)
        withdrawButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        settingsContainer.addArrangedSubview(withdrawButton)
    }
}
