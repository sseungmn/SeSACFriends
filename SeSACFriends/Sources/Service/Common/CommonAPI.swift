//
//  Common.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/26.
//

import Foundation

import Moya
import RxSwift

class CommonAPI {
    static let shared = CommonAPI()
    private init() {}
    
    let provider = MoyaProvider<CommonTarget>()
    
    func refreshFCMtoken(_ FCMtoken: String = SesacUserDefaults.FCMtoken) -> Single<Bool> {
        provider.rx.request(
            .refrechFCMtoken(FCMtoken: FCMtoken)
        )
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
                case 401:
                    throw APIError.firebaseTokenError
                case 500:
                    throw APIError.serverError
                case 501:
                    throw APIError.clientError
                default:
                    throw APIError.undefinedError(statusCode: response.statusCode)
                }
            }
    }
}
