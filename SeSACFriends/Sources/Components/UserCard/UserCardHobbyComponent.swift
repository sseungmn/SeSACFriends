//
//  UserCardHobbyComponent.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/15.
//

import UIKit
import RxSwift

final class UserCardHobbyComponent: UICollectionView, UICollectionViewDelegate {
    var disposeBag = DisposeBag()
    
    private let fixedSpaceLayout = UICollectionViewLayout.hobbyComponentLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: fixedSpaceLayout)
        
        register(HobbyCell.self, forCellWithReuseIdentifier: HobbyCell.reuseID)
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(32)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchInfo(hobby: [String]) {
        delegate = nil
        dataSource = nil
        
        Observable.just(hobby).debug("hobby")
            .bind(to: self.rx.items) { (collectionView, row, element) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCell.reuseID, for: IndexPath(row: row, section: 0)) as? HobbyCell else { return HobbyCell() }
                var title = element
                if element == "anything" { title = "아무거나" }
                debug(title: "title", title)
                cell.setTitle(title)
                cell.othersHobbyStyle()
                return cell
            }
            .disposed(by: disposeBag)
    }
}

extension UICollectionViewLayout {
    static func hobbyComponentLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .absolute(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(8),
            bottom: .fixed(8)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(32)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}

// MARK: Cell
final class HobbyCell: UICollectionViewCell {
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
final class HobbyHeader: UICollectionReusableView {
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
