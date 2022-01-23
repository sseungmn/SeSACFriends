//
//  AuthAPI.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

import RxSwift
import RxAlamofire

class AuthAPI {
    static var shared = AuthAPI()
    
    func isUser(idToken: String) -> Observable<Bool> {
        return request(.get, "http://test.monocoding.com:353484/user",
                       headers: ["idtoken": idToken])
            .response()
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 201:
                    return false
                case 401:
                    throw APIError.firebaseTokenExpired
                case 500:
                    throw APIError.severError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError
                }
            }
    }
}
