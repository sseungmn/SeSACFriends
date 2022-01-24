//
//  Target.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/25.
//

import Foundation
import Moya

enum Common {
    case refrechFCMToken
}

extension Common: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .refrechFCMToken:
            return "/user/update_fcm_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refrechFCMToken:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .refrechFCMToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .refrechFCMToken:
            return ["idtoken": AuthUserDefaults.idtoken]
        }
    }
}

enum AuthTarget {
    case isUser
    case signUp
}

extension AuthTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .isUser:
            return "/user"
        case .signUp:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .isUser:
            return .get
        case .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .isUser:
            return .requestPlain
        case .signUp:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers = ["idtoken": AuthUserDefaults.idtoken]
        if self.method == .post {
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        return headers
    }
}
