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
    }
}
