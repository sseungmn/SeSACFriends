//
//  PropertyWrapper.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import Foundation

@propertyWrapper
class UserDefault<Type> {
    let key: String
    let defaultValue: Type
    
    var wrappedValue: Type {
        get {
            let value = UserDefaults.standard.object(forKey: self.key) as? Type ?? self.defaultValue
            debug(title: "UserDefault getting \(self.key)", value)
            return value
        }
        set {
            debug(title: "UserDefault setting \(self.key)", newValue)
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
    
    init(_ key: String, defaultValue: Type) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

@propertyWrapper
class EnumUserDefault<T: RawRepresentable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let value = UserDefaults.standard.object(forKey: self.key) as? T.RawValue else {
                return self.defaultValue
            }
            return T(rawValue: value) ?? self.defaultValue
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: self.key)
        }
    }
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
