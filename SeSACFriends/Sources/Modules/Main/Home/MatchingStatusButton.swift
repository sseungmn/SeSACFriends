//
//  MatchingStatusButton.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import UIKit

enum MatchingStatus: Int {
    case `default`, waiting, matched
    
    var icon: UIImage {
        switch self {
        case .default:
            return Asset.Assets.mainStatusButton1.image
        case .waiting:
            return Asset.Assets.mainStatusButton2.image
        case .matched:
            return Asset.Assets.mainStatusButton3.image
        }
    }
}

class MatchingStatusButton: UIButton {
    private var status: MatchingStatus = SesacUserDefaults.matchingStatus {
        didSet {
            self.setImage(status.icon, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bounds = CGRect(x: 0, y: 0, width: 64, height: 64)
        self.setImage(status.icon, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMatchingStatus(status: MatchingStatus) {
        self.status = status
    }
}
