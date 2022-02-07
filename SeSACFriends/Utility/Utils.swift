//
//  Utils.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

public func debug(title: String, _ items: Any..., separator: String = " ", terminator: String = "\n") {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
    var output = "DEBUG | \(dateFormatter.string(from: .now)) | "
    output += "\(title) | "
    output += items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
}
