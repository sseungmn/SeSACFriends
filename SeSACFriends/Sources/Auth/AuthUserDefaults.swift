//
//  AuthUserDefaults.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

class AuthUserDefaults {
    @UserDefault("phoneNumber", defaultValue: "") static var phoneNumber: String
    @UserDefault("FCMToken", defaultValue: "") static var FCMtoken: String
    @UserDefault("nick", defaultValue: "") static var nick: String
    @UserDefault("birth", defaultValue: "") static var birth: String
    @UserDefault("email", defaultValue: "") static var email: String
    @UserDefault("gender", defaultValue: -1) static var gender: Int
    
    @UserDefault("verificationID", defaultValue: "") static var verificaitonID: String
    @UserDefault("idtoken", defaultValue: "") static var idtoken: String
}
