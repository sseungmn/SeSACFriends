//
//  SesacAlertViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/06.
//

import UIKit
import Then
import SnapKit

class SesacAlertController: ViewController {
    let backgroundView = UIView().then { view in
        view.backgroundColor = Asset.Colors.black.color
        view.alpha = 0.5
    }
    
    let alertView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
    }
    
    let titleLabel = UILabel().then { label in
        label.font = .Body1_M16
        label.textColor = Asset.Colors.black.color
        label.textAlignment = .center
    }
    
    let messageLabel = UILabel().then { label in
        label.font = .Title4_R14
        label.textColor = Asset.Colors.gray7.color
        label.textAlignment = .center
    }
    
    let buttonStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
    }
    
    let cancelButton = StateButton().then { button in
        button.setTitle("취소", for: .normal)
        button.setStyleState(styleState: .cancel)
    }
    
    let okButton = StateButton().then { button in
        button.setTitle("확인", for: .normal)
        button.setStyleState(styleState: .fill)
    }
    
    init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        titleLabel.text = title
        messageLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(16)
        }
        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        alertView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        alertView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(okButton)
    }
}
