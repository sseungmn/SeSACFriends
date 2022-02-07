//
//  APIKeys.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation

enum APIKeys: String {
    case NMFClientId
}

extension APIKeys {
    var keyString: String {
        guard let file = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else { fatalError("APIKeys.plist 파일이 존재하지 않습니다.") }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("APIKeys.plist 파일의 형식이 알맞지 않습니다.") }
        guard let key = resource[self.rawValue] as? String else { fatalError("해당 API Key가 존재하지 않습니다.")}
        return key
    }
}
