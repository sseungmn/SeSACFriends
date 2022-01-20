//
//  ParagraphLabel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/20.
//

import UIKit

class ParagraphLabel: UILabel {
    let paragraphStyle = NSMutableParagraphStyle()
    override var text: String? {
        didSet {
            guard let text = text else { return }
            attributedText = NSMutableAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
        }
    }
}
