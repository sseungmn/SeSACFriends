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
    @UserDefault("birth", defaultValue: Date(timeIntervalSinceReferenceDate: 0)) static var birth: Date
    @UserDefault("email", defaultValue: "") static var email: String
    @UserDefault("gender", defaultValue: -1) static var gender: Int
    
    @UserDefault("verificationID", defaultValue: "") static var verificaitonID: String
    @UserDefault("idtoken", defaultValue: "") static var idtoken: String
    
    @UserDefault("isUser", defaultValue: false) static var isUser: Bool
    
    static func clearAuthParams() {
        self.phoneNumber = ""
        self.nick = ""
        self.birth = Date(timeIntervalSinceReferenceDate: 0)
        self.email = ""
        self.gender = -1
        self.FCMtoken = ""
        self.idtoken = ""
        self.verificaitonID = ""
    }
}
