//
//  CommonTarget.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/26.
//

import Foundation
import Moya

enum CommonTarget {
    case refrechFCMtoken(FCMtoken: String)
}

extension CommonTarget: TargetType {
    var baseURL: URL {
        return MoyaSupports.shared.baseURL
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
        case .refrechFCMtoken(let FCMtoken):
            let params: [String: Any] = ["FCMtoken": FCMtoken]
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
