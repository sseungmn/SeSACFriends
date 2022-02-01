//
//  Settings.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import Foundation
import UIKit

struct Settings {
    static let shared = Settings()
    private init() {}
    
    var character: SesacCharacter = .basic
    var background: SesacBackground = .skyPark
}

// MARK: SesacCharacter
enum SesacCharacter: Int {
    case basic, strong, mint, purple, gold
}

extension SesacCharacter {
    var image: UIImage {
        switch self {
        case .basic:
            return Asset.Assets.sesacFace1.image
        case .strong:
            return Asset.Assets.sesacFace2.image
        case .mint:
            return Asset.Assets.sesacFace3.image
        case .purple:
            return Asset.Assets.sesacFace4.image
        case .gold:
            return Asset.Assets.sesacFace5.image
        }
    }
}

// MARK: SesacBackground
enum SesacBackground: Int {
    case skyPark, latinLivingRoom
}

extension SesacBackground {
    var image: UIImage {
        switch self {
        case .skyPark:
            return Asset.Assets.sesacBackground1.image
        case .latinLivingRoom:
            return Asset.Assets.sesacBackground2.image
        }
    }
}
