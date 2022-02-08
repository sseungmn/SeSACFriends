//
//  UITextField+Rx.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textFeild, _ in
            textFeild.becomeFirstResponder()
        }
    }
}

extension Reactive where Base: StateTextField {
    var styleState: Binder<TextFieldStyleState> {
        return Binder(self.base) { textField, styleState in
            switch styleState {
            case .normal:
                textField.normalStyle()
            case .focus:
                textField.focusStyle()
            case .disable:
                textField.disableStyle()
            case .error:
                textField.errorStyle()
            case .success:
                textField.successStyle()
            }
        }
    }
}
