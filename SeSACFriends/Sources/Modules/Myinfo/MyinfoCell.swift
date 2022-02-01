//
//  MyinfoCell.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import UIKit
import Then
import SnapKit

class MyinfoCell: UITableViewCell {
    
    let leftImageView = UIImageView().then { imageView in
        imageView.tintColor = Asset.Colors.black.color
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    let titleLabel = UILabel().then { label in
        label.font = .Title2_R16
        label.textColor = Asset.Colors.black.color
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContraint() {
        contentView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(12)
        }
    }
}
