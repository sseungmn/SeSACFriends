//
//  HobbyCollectionView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit

class HobbyCollectionView: UICollectionView {
    
    private let fixedSpacedlayout = UICollectionViewLayout.hobbyCollectionViewLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: fixedSpacedlayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UICollectionViewLayout {
    /// https://augmentedcode.io/2021/08/16/fixed-spaced-flow-layout-with-uicollectionviewcompositionallayout/
    static func hobbyCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(50),
                heightDimension: .absolute(32)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                leading: .none,
                top: .fixed(8),
                trailing: .fixed(8),
                bottom: .none
            )
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(300)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            let headerSize: NSCollectionLayoutSize
            switch sectionIndex {
            case 1:
                headerSize = .init(widthDimension: .absolute(0),
                                   heightDimension: .absolute(0))
                section.contentInsets = .init(top: 0, leading: 0, bottom: 24, trailing: 0)
            default:
                headerSize = .init(widthDimension: .fractionalWidth(1.0),
                                   heightDimension: .absolute(18))
                section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
            }
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .none
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
