//
//  UIButton+Rx.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: StateButton {
   var styleState: Binder<ButtonStyleState> {
        return Binder(self.base) { button, styleState in
            switch styleState {
            case .inactive:
                button.inactiveStyle()
            case .fill:
                button.fillStyle()
            case .outline:
                button.outlineStyle()
            case .cancel:
                button.cancelStyle()
            case .disable:
                button.disableStyle()
            }
        }
    }
}
