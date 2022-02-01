//
//  Date+Extension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/24.
//

import Foundation

extension Date {
    
    func component(for component: Calendar.Component) -> Int? {
        let dateComponent = Calendar.current.dateComponents([component], from: self)
        switch component {
        case .year:
            return dateComponent.year
        case .month:
            return dateComponent.month
        case .day:
            return dateComponent.day
        default:
            return nil
        }
    }
}
