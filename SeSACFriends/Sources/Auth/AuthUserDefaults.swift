//
//  AuthUserDefaults.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

class AuthUserDefaults {
    @UserDefault("phoneNumber", defaultValue: "") static var phoneNumber: String
}
