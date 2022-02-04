//
//  AuthAPI.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

import Moya
import RxSwift

enum AuthCodeError: Error {
    case authCodeExpired
    case idtokenError
    case invalidCode
}

class AuthAPI {
    static let shared = AuthAPI()
    private init() {}
    
    let provider = MoyaProvider<AuthTarget>()
    
    func isUser() -> Single<Bool> {
        return provider.rx.request(.isUser)
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 201:
                    return false
                case 401:
                    throw APIError.firebaseTokenError
                default:
                    throw APIError.undefinedError
                }
            }
        }
    
    func getUser() -> Single<User> {
        return provider.rx.request(.isUser)
            .map { response in
                switch response.statusCode {
                case 200:
                    return try JSONDecoder().decode(User.self, from: response.data)
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.undefinedUser
                default:
                    throw APIError.undefinedError
                }
            }
    }
    
    func signUp(
        phoneNumber: String = AuthUserDefaults.phoneNumber,
        FCMtoken: String = AuthUserDefaults.FCMtoken,
        nick: String = AuthUserDefaults.nick,
        birth: Date = AuthUserDefaults.birth,
        email: String = AuthUserDefaults.email,
        gender: Int = AuthUserDefaults.gender
    ) -> Single<Void> {
        
        let phoneNumber = "+82\(phoneNumber.decimalFilteredString.dropFirst())"
//        let birth = DateFormatter().string(from: birth)
        return provider.rx.request(.signUp(
            phoneNumber: phoneNumber, FCMToken: FCMtoken, nick: nick,
            birth: birth, email: email, gender: gender)
        )
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 201:
                    throw APIError.already
                case 202:
                    throw APIError.invalidNickname
                case 401:
                    throw APIError.firebaseTokenError
                case 500:
                    throw APIError.severError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError
                }
            }
    }
    
    func withDraw() -> Single<Void> {
        return provider.rx.request(.withdraw)
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.already
                case 500:
                    throw APIError.severError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError
                }
            }
    }
    
    func updateUser(
        gender: Int,
        hobby: String,
        searchable: Int,
        ageMin: Int,
        ageMax: Int
    ) -> Single<Void> {
        return provider.rx.request(.updateUser(gender: gender, hobby: hobby, searchable: searchable, ageMin: ageMin, ageMax: ageMax))
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 401:
                    throw APIError.firebaseTokenError
                default:
                    throw APIError.undefinedError
                }
            }
    }
}
