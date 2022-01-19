//
//  Button+Component.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import UIKit

import RxSwift
import RxCocoa

enum ButtonStyleState: String {
    case inactive, fill, outline, cancel, disable
}

class StateButton: UIButton {
    var styleState = BehaviorRelay<ButtonStyleState>(value: .inactive)
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        
        styleState
            .bind(to: self.rx.styleState)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StateButton {
    // style
    func inactiveStyle() {
        self.layer.borderColor = UIColor.gray4.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .customWhite
        self.setTitleColor(.customBlack, for: .normal)
    }
    func fillStyle() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.backgroundColor = .brandGreen
        self.setTitleColor(.customWhite, for: .normal)
    }
    func outlineStyle() {
        self.layer.borderColor = UIColor.brandGreen.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .customWhite
        self.setTitleColor(.brandGreen, for: .normal)
    }
    func cancelStyle() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.backgroundColor = .gray2
        self.setTitleColor(.customBlack, for: .normal)
    }
    func disableStyle() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.backgroundColor = .gray6
        self.setTitleColor(.gray3, for: .normal)
    }
}

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
