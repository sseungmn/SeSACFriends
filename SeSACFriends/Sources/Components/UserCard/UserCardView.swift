//
//  UserCardView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit

class UserCardView: View {
    let cardImageView = UserCardImageView()
    let titleComponent = SesacTitleView(isUserInteractionEnabled: false)
    
    override func setConstraint() {
        addSubview(cardImageView)
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        addSubview(titleComponent)
        titleComponent.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        self.snp.makeConstraints { make in
            make.bottom.equalTo(titleComponent)
        }
    }
}
