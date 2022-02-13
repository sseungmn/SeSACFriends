//
//  QueueAPI.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation
import Moya
import RxSwift

enum QueueError: Error {
    case banned, penalty(level: Int), needGenderSelection
}

extension QueueError: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.banned, .banned),
            (.needGenderSelection, .needGenderSelection):
            return true
        case (let .penalty(Llevel), let .penalty(Rlevel)):
            return Llevel == Rlevel
        default:
            return false
        }
    }
}

class QueueAPI {
    static let shared = QueueAPI()
    private init() {}
    
    let provider = MoyaProvider<QueueTarget>()
    
    func onqueue(lat: Double, long: Double) -> Single<Onqueue> {
        let region = region(lat: lat, long: long)
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
    
    func postQueue(type: Int = 2, lat: Double, long: Double, hf: [String]) -> Single<Void> {
        let region = region(lat: lat, long: long)
        return provider.rx.request(
            .postQueue(
                type: type,
                region: region,
                lat: lat,
                long: long,
                hf: hf
            ))
            .map { response in
                switch response.statusCode {
                case 200:
                    return ()
                case 201:
                    throw QueueError.banned
                case 203:
                    throw QueueError.penalty(level: 1)
                case 204:
                    throw QueueError.penalty(level: 2)
                case 205:
                    throw QueueError.penalty(level: 3)
                case 206:
                    throw QueueError.needGenderSelection
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

extension QueueAPI {
    private func region(lat: Double, long: Double) -> Int {
        let subLat = Array(String((lat + 90) * 10000))[0..<5]
        let subLong = Array(String((long + 180) * 10000))[0..<5]
        return Int(String(subLat + subLong))!
    }
}
