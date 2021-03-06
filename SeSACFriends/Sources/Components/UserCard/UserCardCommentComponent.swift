//
//  UserCardCommentComponent.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import Then
import SnapKit

class UserCardCommentComponent: View {
    let firstCommentLabel = UILabel().then { label in
        label.font = .Body3_R14
        label.textColor = Asset.Colors.gray6.color
        label.numberOfLines = 0
        label.text = "첫 리뷰를 기다리는 중이에요!"
    }
    
    override func setConstraint() {
        addSubview(firstCommentLabel)
        firstCommentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func fetchInfo(comment: String?) {
        if let comment = comment {
            firstCommentLabel.text = comment
        }
    }
}
