//
//  Target.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/25.
//

import Foundation
import Moya

enum AuthTarget {
    case isUser
    case signUp
    case withdraw
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
        case .withdraw:
            return "/user/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .isUser:
            return .get
        case .signUp:
            return .post
        case .withdraw:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .isUser:
            return .requestPlain
        case .signUp:
            let params: [String: Any] = [
                "phoneNumber": AuthUserDefaults.phoneNumber,
                "FCMtoken": AuthUserDefaults.FCMtoken,
                "nick": AuthUserDefaults.nick,
                "birth": AuthUserDefaults.birth,
                "email": AuthUserDefaults.email,
                "gender": AuthUserDefaults.gender
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        var headers = MoyaSupports.Headers.idtoken.toDict()
        if self == .signUp {
            headers.append(MoyaSupports.Headers.contentType(.form).toDict())
        }
        debug(title: "headers", headers)
        return headers
    }
}
