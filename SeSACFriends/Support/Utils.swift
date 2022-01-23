//
//  Utils.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

public func debug(title: String, _ items: Any..., separator: String = " ", terminator: String = "\n") {
  var output = "DEBUG(\(title) : "
  output += items.map { "\($0)" }.joined(separator: separator)
  Swift.print(output, terminator: terminator)
}
