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
    
    let provider = MoyaProvider<CommonTarget>()
    
    func refreshFCMtoken() -> Single<Bool> {
        provider.rx.request(.refrechFCMtoken)
            .map { response in
                switch response.statusCode {
                case 200:
                    return true
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
}
