//
//  UIView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import UIKit

extension UIView {
    func setShadow(
        shadowOpacity: Float = 1,
        shadowOffset: CGSize = CGSize(width: 0, height: 1),
        shadowRadius: CGFloat = 3
    ) {
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
}
