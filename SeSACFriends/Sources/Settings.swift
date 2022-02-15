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
enum SesacCharacter: Int, CaseIterable {
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
enum SesacBackground: Int, CaseIterable {
    case skyPark, cityView, nightTrail, dayTrail, stage, latinLivingroom, homeTrainingRoom, musicianRoom
}

extension SesacBackground {
    var image: UIImage {
        switch self {
        case .skyPark:
            return Asset.Assets.sesacBackground1.image
        case .cityView:
            return Asset.Assets.sesacBackground2.image
        case .nightTrail:
            return Asset.Assets.sesacBackground3.image
        case .dayTrail:
            return Asset.Assets.sesacBackground4.image
        case .stage:
            return Asset.Assets.sesacBackground5.image
        case .latinLivingroom:
            return Asset.Assets.sesacBackground6.image
        case .homeTrainingRoom:
            return Asset.Assets.sesacBackground7.image
        case .musicianRoom:
            return Asset.Assets.sesacBackground8.image
        }
    }
}
