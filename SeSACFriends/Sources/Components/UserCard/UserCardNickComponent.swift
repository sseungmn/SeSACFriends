//
//  NickView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit

final class UserCardNickComponent: View {
    
    let nickLabel = UILabel().then { label in
        label.font = .Title1_M16
        label.textColor = Asset.Colors.black.color
        label.text = SesacUserDefaults.nick
    }
    
    let openCloseImageView = UIImageView().then { imageView in
        imageView.tintColor = Asset.Colors.gray7.color
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.down")!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraint() {
        addSubview(nickLabel)
        nickLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        addSubview(openCloseImageView)
        openCloseImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.trailing.equalToSuperview()
        }
    }
}
