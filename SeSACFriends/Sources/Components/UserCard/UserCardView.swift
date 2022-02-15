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
    var withHobby: Bool
    var isCardClosed: Bool! {
        didSet {
            var image: UIImage
            if isCardClosed == true {
                image = UIImage(systemName: "chevron.down")!
            } else {
                image = UIImage(systemName: "chevron.up")!
            }
            nickContrainer.openCloseImageView.image = image
            reputationContainer.isHidden = isCardClosed
            hobbyContainer.isHidden = isCardClosed
            commentContainer.isHidden = isCardClosed
        }
    }
    
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
    let nickContrainer = UserCardNickComponent()
    let reputationContainer = UserCardSubContainer(
        title: "새싹 타이틀",
        content: ReputationComponent(isUserInteractionEnabled: false)
    )
    let hobbyContainer = UserCardSubContainer(
        title: "하고 싶은 취미",
        content: UserCardHobbyComponent()
    )
    let commentContainer = UserCardSubContainer(
        title: "새싹 리뷰",
        content: UserCardCommentComponent()
    )

    init(withHobby: Bool = false) {
        self.withHobby = withHobby
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        isCardClosed = true
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
            make.trailing.leading.bottom.equalToSuperview()
        }
        contentView.addArrangedSubview(nickContrainer)
        contentView.addArrangedSubview(reputationContainer)
        if withHobby {
            contentView.addArrangedSubview(hobbyContainer)
        }
        contentView.addArrangedSubview(commentContainer)
    }
    
    func fetchInfo(with user: QueuedUser) {
        cardImageView.fetchInfo(background: SesacBackground.allCases[user.background], character: SesacCharacter.allCases[user.sesac])
        nickContrainer.fetchInfo(nick: user.nick)
        guard let reputationView = reputationContainer.content as? ReputationComponent,
              let hobbyView = hobbyContainer.content as? UserCardHobbyComponent,
              let commentView = commentContainer.content as? UserCardCommentComponent else { return }
        reputationView.fetchInfo(reputation: user.reputation)
        hobbyView.fetchInfo(hobby: user.hf)
    }
}

final class UserCardSubContainer: View {
    private let titleLabel = UILabel().then { label in
        label.font = .Title6_R12
        label.textColor = Asset.Colors.black.color
    }
    
    let contentView = UIStackView()
    var content: UIView!
    
    init(title: String, content: UIView) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.contentView.addArrangedSubview(content)
        self.content = content
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
