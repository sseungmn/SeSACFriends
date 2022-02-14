//
//  SearchEmptyView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/14.
//

import UIKit
import Then
import SnapKit

class SearchEmptyView: View {
    let logoImageView = UIImageView().then { imageView in
        imageView.image = Asset.Assets.img.image
    }
    
    let titleLabel = UILabel().then { label in
        label.text = "아쉽게도 주변에 새싹이 없어요ㅠ"
        label.font = .Display1_R20
    }
    
    let subtitleLabel = UILabel().then { label in
        label.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        label.font = .Title4_R14
        label.textColor = Asset.Colors.gray7.color
    }
    
    let changeHobbyButton = StateButton().then { button in
        button.setTitle("취미 변경하기", for: .normal)
        button.setStyleState(styleState: .fill)
    }
    
    let retryButton = StateButton().then { button in
        button.setImage(Asset.Assets.refresh.image, for: .normal)
        button.setStyleState(styleState: .outline)
    }
    
    override func setConstraint() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-32)
        }
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        addSubview(retryButton)
        retryButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
        addSubview(changeHobbyButton)
        changeHobbyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(retryButton.snp.leading).offset(-8)
            make.height.equalTo(48)
        }
    }
}
