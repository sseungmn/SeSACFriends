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
    case signUp(
        phoneNumber: String,
        FCMToken: String,
        nick: String,
        birth: Date,
        email: String,
        gender: Int)
    case withdraw
    case updateUser(
        gender: Int,
        hobby: String,
        searchable: Int,
        ageMin: Int,
        ageMax: Int
    )
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
        case .updateUser:
            return "/user/update/mypage"
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
        case .updateUser:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .isUser:
            return .requestPlain
        case .signUp(let phoneNumber, let FCMtoken, let nick,
                     let birth, let email, let gender):
            let params: [String: Any] = [
                "phoneNumber": phoneNumber,
                "FCMtoken": FCMtoken,
                "nick": nick,
                "birth": birth,
                "email": email,
                "gender": gender
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .withdraw:
            return .requestPlain
        case .updateUser(let gender, let hobby, let searchable, let ageMin, let ageMax):
            let params: [String: Any] = [
                "gender": gender,
                "hobby": hobby,
                "searchable": searchable,
                "ageMin": ageMin,
                "ageMax": ageMax
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = MoyaSupports.Headers.idtoken.toDict()
        switch self {
        case .signUp, .updateUser:
            headers.append(MoyaSupports.Headers.contentType(.form).toDict())
        default: break
        }
        debug(title: "headers", headers)
        return headers
    }
}
