//
//  UserCardImageView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import SnapKit

final class UserCardImageView: View {
    
    let backgroundImageView = UIImageView().then { imageView in
        imageView.image = Settings.shared.background.image
    }
    
    let characterImageView = UIImageView().then { imageView in
        imageView.image = Settings.shared.character.image
    }
    
    override func configure() {
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
    
    override func setConstraint() {
        snp.makeConstraints { make in
            make.height.equalTo(194)
        }
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(characterImageView)
        characterImageView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
    }
}
