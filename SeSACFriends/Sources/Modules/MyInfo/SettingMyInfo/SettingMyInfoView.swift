//
//  SettingMyInfoView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import SnapKit

class SettingMyInfoView: View {
    let userCardView = UserCardView()
    
    override func setConstraint() {
        addSubview(userCardView)
        userCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
