//
//  HobbyView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/10.
//

import UIKit
import Then
import SnapKit

class HobbyView: View {
    var hobbyCollectionView = HobbyCollectionView()
    var sesacSearchButton = StateButton().then { button in
        button.setTitle("새싹 찾기", for: .normal)
        button.setStyleState(styleState: .fill)
    }
    
    override func configure() {
        hobbyCollectionView.register(HobbyCell.self, forCellWithReuseIdentifier: HobbyCell.reuseID)
        hobbyCollectionView.register(HobbyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HobbyHeader.reuseID)
    }
    
    override func setConstraint() {
        addSubview(hobbyCollectionView)
        hobbyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        addSubview(sesacSearchButton)
        sesacSearchButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
    
    func updateButtonY(with keyboardHeight: CGFloat) {
        debug(title: "keyboard", keyboardHeight)
        if keyboardHeight == 0 {
            sesacSearchButton.layer.cornerRadius = 8
            sesacSearchButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
                make.height.equalTo(48)
            }
        } else {
            sesacSearchButton.layer.cornerRadius = 0
            sesacSearchButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().inset(keyboardHeight)
                make.height.equalTo(48)
            }
        }
    }
}
