//
//  StateChangeable.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/20.
//

import Foundation

import RxSwift
import RxRelay

// Generic Protocol

protocol StyleStateChangebale {
    associatedtype StyleState: RawRepresentable
    var styleState: PublishRelay<StyleState> { get }
    var disposeBag: DisposeBag { get set }
    func setStyleState(styleState: StyleState)
}
