//
//  QueueTarget.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation
import Moya

enum QueueTarget {
    case onqueue(
        region: Int,
        lat: Double,
        long: Double
    )
}

extension QueueTarget: TargetType {
    var baseURL: URL {
        return MoyaSupports.shared.baseURL.appendingPathComponent("/queue")
    }
    
    var path: String {
        switch self {
        case .onqueue:
            return "/onqueue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .onqueue:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .onqueue(
            let region,
            let lat,
            let long
        ):
            let params: [String: Any] = [
                "region": region,
                "lat": lat,
                "long": long
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = MoyaSupports.Headers.idtoken.toDict()
        switch self {
        case .onqueue:
            headers.append(MoyaSupports.Headers.contentType(.form).toDict())
        }
        return headers
    }
    
}
