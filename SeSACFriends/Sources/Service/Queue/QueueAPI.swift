//
//  QueueAPI.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation
import Moya
import RxSwift

class QueueAPI {
    static let shared = QueueAPI()
    private init() {}
    
    let provider = MoyaProvider<QueueTarget>()
    
    func onqueue(lat: Double, long: Double) -> Single<Onqueue> {
        let subLat = Array(String((lat + 90) * 10000))[0..<5]
        let subLong = Array(String((long + 180) * 10000))[0..<5]
        let region = Int(String(subLat + subLong))!
        return provider.rx.request(
            .onqueue(
                region: region,
                lat: lat,
                long: long
            ))
            .map { response in
                switch response.statusCode {
                case 200:
                    return try JSONDecoder().decode(Onqueue.self, from: response.data)
                case 401:
                    throw APIError.firebaseTokenError
                case 406:
                    throw APIError.undefinedUser
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
