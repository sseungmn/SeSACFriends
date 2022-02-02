//
//  SesacTitleView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit

final class ReputationComponent: View {
    let spacing: CGFloat = 8
    lazy var stackViewCol = UIStackView().then { stackView in
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
    }
    lazy var stackViewRow1 = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
    }
    let goodMannerButton = ReputationButton(titleType: .goodManner)
    let punctualButton = ReputationButton(titleType: .punctual)
    lazy var stackViewRow2 = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
    }
    let responsiveButton = ReputationButton(titleType: .responsive)
    let kindnessButton = ReputationButton(titleType: .kindness)
    lazy var stackViewRow3 = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
    }
    let proficientButton = ReputationButton(titleType: .proficient)
    let userTimeButton = ReputationButton(titleType: .usefulTime)
    
    init(isUserInteractionEnabled: Bool) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        addSubview(stackViewCol)
        stackViewCol.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackViewCol.addArrangedSubview(stackViewRow1)
        stackViewRow1.addArrangedSubview(goodMannerButton)
        stackViewRow1.addArrangedSubview(punctualButton)
        
        stackViewCol.addArrangedSubview(stackViewRow2)
        stackViewRow2.addArrangedSubview(responsiveButton)
        stackViewRow2.addArrangedSubview(kindnessButton)
        
        stackViewCol.addArrangedSubview(stackViewRow3)
        stackViewRow3.addArrangedSubview(proficientButton)
        stackViewRow3.addArrangedSubview(userTimeButton)
    }
}

enum ReputationType: Int {
    case goodManner, punctual, responsive, kindness, proficient, usefulTime
}

extension ReputationType {
    var title: String {
        switch self {
        case .goodManner:
            return "좋은 매너"
        case .punctual:
            return "정확한 시간 약속"
        case .responsive:
            return "빠른 응답"
        case .kindness:
            return "친절한 성격"
        case .proficient:
            return "능숙한 취미 실력"
        case .usefulTime:
            return "유익한 시간"
        }
    }
}

final class ReputationButton: StateButton {
    var reputationType: ReputationType
    
    init(titleType: ReputationType) {
        self.reputationType = titleType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        setStyleState(styleState: .inactive)
        setTitle(reputationType.title, for: .normal)
        setTitleColor(Asset.Colors.black.color, for: .normal)
        titleLabel?.font = .Title4_R14
    }
    
    override func setConstraint() {
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
    }
    
    override func bind() {
        super.bind()
        self.rx.tap
            .withUnretained(self)
            .map { (owner, tap) -> ButtonStyleState in
                owner.isSelected.toggle()
                switch owner.isSelected {
                case true:
                    return .fill
                case false:
                    return .inactive
                }
            }
            .bind(to: self.styleState)
            .disposed(by: disposeBag)
    }
}

