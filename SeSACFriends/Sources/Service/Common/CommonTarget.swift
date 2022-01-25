//
//  CommonTarget.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/26.
//

import Foundation
import Moya

enum CommonTarget {
    case refrechFCMtoken
}

extension CommonTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://test.monocoding.com:35484")!
    }
    
    var path: String {
        switch self {
        case .refrechFCMtoken:
            return "/user/update_fcm_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refrechFCMtoken:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .refrechFCMtoken:
            let params: [String: Any] = ["FCMtoken": AuthUserDefaults.FCMtoken]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = [String: String]()
        switch self {
        case .refrechFCMtoken:
            headers.append(MoyaSupports.Headers.idtoken.toDict())
            headers.append(MoyaSupports.Headers.contentType(.form).toDict())
        }
        debug(title: "headers", headers)
        return headers
    }
}
