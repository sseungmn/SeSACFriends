//
//  AuthBaseView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/20.
//

import UIKit

import Then

class AuthBaseView: UIView {
    let titleLabel = ParagraphLabel().then { label in
        label.font = .Display1_R20
        label.paragraphStyle.lineHeightMultiple = 1.08
        label.paragraphStyle.alignment = .center
        label.numberOfLines = 0
    }
    let subtitleLabel = ParagraphLabel().then { label in
        label.font = .Title2_R16
        label.textColor = Asset.Colors.gray7.color
        label.paragraphStyle.lineHeightMultiple = 1.08
        label.paragraphStyle.alignment = .center
    }
    let descriptionView = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
    }
    
    let userInputView = UIView()
    
    let button = StateButton(initialStyleState: .disable)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    func setConstraint() {
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            let remainHeight = UIScreen.main.bounds.height - 290
            make.top.equalToSuperview().inset(remainHeight * 0.32) // not navigationbar
            make.centerX.equalToSuperview()
            make.height.equalTo(64)
        }
        addSubview(userInputView)
        userInputView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(184)
        }
        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(userInputView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}

extension AuthBaseView {
    func setDescriptionTitle(title: String) {
        descriptionView.addArrangedSubview(titleLabel)
        titleLabel.text = title
    }
    func setDescriptionSubtitle(subtitle: String) {
        descriptionView.addArrangedSubview(subtitleLabel)
        descriptionView.spacing = 8
        subtitleLabel.text = subtitle
    }
    func addUserInputComponent<View: UIView>(component: View) {
        userInputView.addSubview(component)
        component.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    func setButtonTitle(title: String) {
        button.setTitle(title, for: .normal)
    }
}
