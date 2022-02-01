//
//  MyinfoSection.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import Foundation
import UIKit

enum MyinfoSection {
    case user(title: String, items: [MyInfoSectionItem])
}

enum MyInfoSectionItem {
    case notice
    case faq
    case qna
    case settingAlarm
    case permit
}

extension MyInfoSectionItem {
    var image: UIImage {
        switch self {
        case .notice:
            return Asset.Assets.notice.image
        case .faq:
            return Asset.Assets.faq.image
        case .qna:
            return Asset.Assets.qna.image
        case .settingAlarm:
            return Asset.Assets.settingAlarm.image
        case .permit:
            return Asset.Assets.permit.image
        }
    }
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .faq:
            return "자주 묻는 질문"
        case .qna:
            return "1:1 문의"
        case .settingAlarm:
            return "알림 설정"
        case .permit:
            return "이용 약관"
        }
    }
}
