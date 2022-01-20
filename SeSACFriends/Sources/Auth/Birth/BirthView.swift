//
//  BirthView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

import Then

final class BirthTextField: StateTextField {
    let suffixLabel = UILabel().then { label in
        label.font = .Title2_R16
        label.textColor = Asset.Colors.black.color
    }
    
    override func configure() {
        super.configure()
        
        setStyleState(styleState: .normal)
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        addSubview(suffixLabel)
        suffixLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
        }
    }
}

class BirthView: AuthBaseView {
    let yearTextField = BirthTextField().then { textField in
        textField.suffixLabel.text = "년"
    }
    let monthTextField = BirthTextField().then { textField in
        textField.suffixLabel.text = "월"
    }
    let dayTextField = BirthTextField().then { textField in
        textField.suffixLabel.text = "일"
    }
    
    let dateStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 23
    }
    
    let datePicker = UIDatePicker().then { datePicker in
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date.now)
    }
    
    override func configure() {
        super.configure()
        
        setDescriptionTitle(title: "생년월일을 알려주세요")
        addUserInputComponent(component: dateStackView)
        setButtonTitle(title: "다음")
        
        yearTextField.inputView = datePicker
        monthTextField.inputView = datePicker
        dayTextField.inputView = datePicker
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        dateStackView.addArrangedSubview(yearTextField)
        dateStackView.addArrangedSubview(monthTextField)
        dateStackView.addArrangedSubview(dayTextField)
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(216)
        }
    }
}
