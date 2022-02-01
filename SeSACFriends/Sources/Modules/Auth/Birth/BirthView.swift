//
//  BirthView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

import Then

class BirthComponentView: UIStackView {
    let textField = StateTextField().then { textField in
        textField.setStyleState(styleState: .normal)
    }
    let suffixLabel = UILabel().then { label in
        label.font = .Title2_R16
        label.textColor = Asset.Colors.black.color
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fill
        addArrangedSubview(textField)
        addArrangedSubview(suffixLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSuffixText(text: String) {
        suffixLabel.text = text
        suffixLabel.sizeToFit()
    }
}

class BirthView: AuthView {
    let yearComponentView = BirthComponentView().then { view in
        view.suffixLabel.text = "년"
    }
    let monthComponentView = BirthComponentView().then { view in
        view.suffixLabel.text = "월"
    }
    let dayComponentView = BirthComponentView().then { view in
        view.suffixLabel.text = "일"
    }
    
    let dateStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 23
    }
    let blockView = UIView().then { view in
        view.backgroundColor = nil
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
        
        yearComponentView.textField.inputView = datePicker
        monthComponentView.textField.inputView = datePicker
        dayComponentView.textField.inputView = datePicker
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        dateStackView.addArrangedSubview(yearComponentView)
        dateStackView.addArrangedSubview(monthComponentView)
        dateStackView.addArrangedSubview(dayComponentView)
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(216)
        }
        
        dateStackView.addSubview(blockView)
        blockView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
