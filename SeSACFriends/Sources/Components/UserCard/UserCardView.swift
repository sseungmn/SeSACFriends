//
//  UserCardView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture

final class UserCardView: View {
    
    var disposeBag = DisposeBag()
    var isCardClose = BehaviorRelay<Bool>(value: true)
    
    let cardImageView = UserCardImageView()
    let contentView = UIStackView().then { stackView in
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = Asset.Colors.gray2.color.cgColor
        stackView.layer.cornerRadius = 8
        
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fill
    }
    private let nickContrainer = UserCardNickComponent()
    private let reputationContainer = UserCardSubContainer(
        title: "새싹 타이틀",
        content: ReputationComponent(isUserInteractionEnabled: false)
    )
    private let commentContainer = UserCardSubContainer(
        title: "새싹 리뷰",
        content: UserCardCommentComponent()
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom)
            make.trailing.leading.equalToSuperview()
        }
        contentView.addArrangedSubview(nickContrainer)
        contentView.addArrangedSubview(reputationContainer)
        contentView.addArrangedSubview(commentContainer)
        
        self.snp.makeConstraints { make in
            make.bottom.equalTo(contentView)
        }
    }
    
    func bind() {
        let isCardOpenDriver = isCardClose.asDriver()
        
        nickContrainer.rx.tapGesture()
            .when(.recognized)
            .scan(true) { last, _ in !last }
            .bind(to: isCardClose)
            .disposed(by: disposeBag)
        
        isCardOpenDriver
            .map { isCardOpen -> UIImage in
                switch isCardOpen {
                case true:
                    return UIImage(systemName: "chevron.down")!
                case false:
                    return UIImage(systemName: "chevron.up")!
                }
            }
            .drive(nickContrainer.openCloseImageView.rx.image)
            .disposed(by: disposeBag)
        
        isCardOpenDriver
            .drive(
                reputationContainer.rx.isHidden,
                commentContainer.rx.isHidden
            )
            .disposed(by: disposeBag)
    }
}

final private class UserCardSubContainer: View {
    private let titleLabel = UILabel().then { label in
        label.font = .Title6_R12
        label.textColor = Asset.Colors.black.color
    }
    
    private let contentView = UIStackView()
    
    init(title: String, content: View) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.contentView.addArrangedSubview(content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
