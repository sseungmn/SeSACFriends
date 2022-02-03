//
//  SettingSearchableComponent.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/03.
//

import UIKit

class SettingSearchableComponent: View {
    let titleLabel = UILabel().then { label in
        label.font = .Title4_R14
        label.textColor = Asset.Colors.black.color
        label.text = "내 번호 검색 허용"
    }
    
    let `switch` = UISwitch().then { `switch` in
        `switch`.preferredStyle = .sliding
        `switch`.tintColor = Asset.Colors.brandGreen.color
    }
    
    override func setConstraint() { snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        addSubview(`switch`)
        `switch`.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
}
