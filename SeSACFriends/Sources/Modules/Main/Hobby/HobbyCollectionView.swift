//
//  HobbyCollectionView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit

class HobbyCollectionView: UICollectionView {
    
    private let fixedSpacedlayout = UICollectionViewLayout.fixedSpacedFlowLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: fixedSpacedlayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Cell
class HobbyCell: UICollectionViewCell {
    private var themeColor: UIColor! {
        didSet {
            tintColor = themeColor
            titleLabel.textColor = themeColor
            layer.borderColor = themeColor.cgColor
        }
    }
    
    private var titleColor: UIColor! {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    private let contentStackView = UIStackView().then { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
    }
    
    private let titleLabel = UILabel().then { label in
        label.font = .Title4_R14
    }
    
    private let xmarkImageView = UIImageView().then { imageView in
        imageView.image = Asset.Assets.closeSmall.image
            .withTintColor(Asset.Colors.brandGreen.color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
    }
    
    private func setContraints() {
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(xmarkImageView)
        xmarkImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
    
    func setTitle(_ title: String) {
        print(title)
        titleLabel.text = title
    }
    
    func recommendedHobbyStyle() {
        themeColor = Asset.Colors.error.color
        titleColor = Asset.Colors.error.color
        contentStackView.spacing = 0
        xmarkImageView.isHidden = true
    }
    
    func othersHobbyStyle() {
        themeColor = Asset.Colors.gray4.color
        titleColor = Asset.Colors.black.color
        contentStackView.spacing = 0
        xmarkImageView.isHidden = true
    }
    
    func myHobbyStyle() {
        themeColor = Asset.Colors.brandGreen.color
        titleColor = Asset.Colors.brandGreen.color
        contentStackView.spacing = 6
        xmarkImageView.isHidden = false
    }
}

// MARK: Header
class HobbyHeader: UICollectionReusableView {
    private let titleLabel = UILabel().then { label in
        label.font = .Title6_R12
        label.textColor = Asset.Colors.black.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setContraints() {
        snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension UICollectionViewLayout {
    /// https://augmentedcode.io/2021/08/16/fixed-spaced-flow-layout-with-uicollectionviewcompositionallayout/
    static func fixedSpacedFlowLayout() -> UICollectionViewLayout {
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
