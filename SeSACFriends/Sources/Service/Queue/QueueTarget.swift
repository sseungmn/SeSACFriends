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
    case postQueue(
        type: Int,
        region: Int,
        lat: Double,
        long: Double,
        hf: [String]
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
        case .postQueue:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .onqueue, .postQueue:
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
        case .postQueue(
            let type,
            let region,
            let lat,
            let long,
            let hf
        ):
            let params: [String: Any] = [
                "type": type,
                "region": region,
                "lat": lat,
                "long": long,
                "hf": hf
            ]
            debug(title: "params", params)
            return .requestParameters(parameters: params, encoding: URLEncoding(arrayEncoding: .noBrackets))
        }
    }
    
    var headers: [String: String]? {
        var headers = MoyaSupports.Headers.idtoken.toDict()
        switch self {
        case .onqueue, .postQueue:
            headers.append(MoyaSupports.Headers.contentType(.form).toDict())
        }
        debug(title: "headers", headers)
        return headers
    }
    
}
