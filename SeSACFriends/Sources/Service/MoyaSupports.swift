//
//  Supports.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/26.
//

import Foundation

enum APIError: Error {
    case firebaseTokenError, serverError, clientError
    case invalidNickname
    case already, undefinedUser
    case undefinedError(statusCode: Int? = nil)
}

extension APIError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.firebaseTokenError, .firebaseTokenError),
            (.serverError, .serverError),
            (.clientError, .clientError),
            (.invalidNickname, .invalidNickname),
            (.already, .already),
            (.undefinedUser, .undefinedUser):
            return true
        case (let .undefinedError(statusCode1), let .undefinedError(statusCode2)):
            if let statusCode1 = statusCode1,
               let statusCode2 = statusCode2 {
                return statusCode1 == statusCode2
            }
            return true
        default:
            return false
        }
    }
}

class MoyaSupports {
    static let shared = MoyaSupports()
    
    var baseURL = URL(string: "http://test.monocoding.com:35484")!
    
    enum Headers {
        case idtoken
        case contentType(_ type: ContentType)
        
        func toDict() -> [String: String] {
            switch self {
            case .idtoken:
                return ["idtoken": SesacUserDefaults.idtoken]
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
