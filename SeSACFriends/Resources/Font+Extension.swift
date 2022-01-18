//
//  Font+Extension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

extension UIFont {
    private static var NotoSansKR_R: UIFont {
        UIFont(name: "NotoSansKR-Regular", size: 10)!
    }
    private static var NotoSansKR_M: UIFont {
        UIFont(name: "NotoSansKR-Medium", size: 10)!
    }
    
    static var Display1_R20: UIFont {
        .NotoSansKR_R.withSize(20)
    }
    static var Title1_M16: UIFont {
        .NotoSansKR_M.withSize(16)
    }
    static var Title2_R16: UIFont {
        .NotoSansKR_R.withSize(16)
    }
    static var Title3_M14: UIFont {
        .NotoSansKR_M.withSize(14)
    }
    static var Title4_R14: UIFont {
        .NotoSansKR_R.withSize(14)
    }
    static var Title5_M12: UIFont {
        .NotoSansKR_M.withSize(12)
    }
    static var Title5_R12: UIFont {
        .NotoSansKR_R.withSize(12)
    }
    static var Body1_M16: UIFont {
        .NotoSansKR_M.withSize(16)
    }
    static var Body2_R16: UIFont {
        .NotoSansKR_R.withSize(16)
    }
    static var Body3_R14: UIFont {
        .NotoSansKR_R.withSize(14)
    }
    static var Body4_R12: UIFont {
        .NotoSansKR_R.withSize(12)
    }
    static var caption_R10: UIFont {
        .NotoSansKR_R.withSize(10)
    }
}
