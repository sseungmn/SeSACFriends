//
//  UIViewController+Rx.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
