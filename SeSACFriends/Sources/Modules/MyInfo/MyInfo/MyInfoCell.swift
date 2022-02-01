//
//  MyinfoCell.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import UIKit
import Then
import SnapKit

final class MyInfoTitleCell: UITableViewCell {
    
    let containerView = UIView().then { view in
        view.backgroundColor = nil
    }
    
    let leftImageView = UIImageView().then { imageView in
        imageView.image = Asset.Assets.profileImg.image
    }
    
    let nameLabel = UILabel().then { label in
        label.font = .Title1_M16
        label.textColor = Asset.Colors.black.color
    }
    
    let moreArrowImageView = UIImageView().then { imageView in
        imageView.image = Asset.Assets.moreArrow.image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        selectionStyle = .none
    }
    
    func setContraint() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
        }
        containerView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(13)
            make.centerY.equalToSuperview()
        }
        containerView.addSubview(moreArrowImageView)
        moreArrowImageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
}

final class MyInfoCell: UITableViewCell {
    
//    var showSeparator: Bool = false {
//        didSet {
//            switch showSeparator {
//            case true:
//                separatorView.isHidden = false
//            case false:
//                separatorView.isHidden = true
//            }
//        }
//    }
    
//    let contentView = UIView().then { view in
//        view.backgroundColor = nil
//    }
    
//    let separatorView = UIView().then { separator in
//        separator.backgroundColor = Asset.Colors.gray2.color
//        separator.snp.makeConstraints { make in
//            make.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(1)
//        }
//    }
    let containerView = UIView().then { view in
        view.backgroundColor = nil
    }
    
    let leftImageView = UIImageView()
    
    let titleLabel = UILabel().then { label in
        label.font = .Title2_R16
        label.textColor = Asset.Colors.black.color
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        selectionStyle = .none
    }
    
    func setContraint() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(17)
        }
        containerView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftImageView.snp.right).offset(12)
        }
    }
}
