//
//  Dictionary+Extension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/26.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    mutating func append(_ anotherDict: [String: String]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}
