//
//  Supports.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/26.
//

import Foundation

enum APIError: Error {
    case firebaseTokenError, severError, clientError
    case invalidNickname
    case already, undefinedUser
    case undefinedError
}

class MoyaSupports {
    static let shared = MoyaSupports()
    
    enum Headers {
        case idtoken
        case contentType(_ type: ContentType)
        
        func toDict() -> [String: String] {
            switch self {
            case .idtoken:
                return ["idtoken": AuthUserDefaults.idtoken]
            case .contentType(let type):
                switch type {
                case .json:
                    return ["Content-Type": "application/json"]
                case .form:
                    return ["Content-Type": "application/x-www-form-urlencoded"]
                }
            }
        }
    }
    
    enum ContentType {
        case json
        case form
    }
}
