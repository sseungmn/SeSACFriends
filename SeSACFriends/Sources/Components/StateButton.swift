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

class StateButton: UIButton, StyleStateChangebale {
    
    // StaeChangeable Conformance
    typealias StyleState = ButtonStyleState
    var styleState = PublishRelay<ButtonStyleState>()
    var disposeBag = DisposeBag()
    
    convenience init(initialStyleState styleState: ButtonStyleState) {
        self.init(frame: .zero)
        setStyleState(styleState: styleState)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        configure()
        setConstraint()
    }
    
    func bind() {
        styleState
            .asDriver(onErrorJustReturn: .disable)
            .drive(self.rx.styleState)
            .disposed(by: disposeBag)
    }
    
    func configure() {
        self.layer.cornerRadius = 8
        titleLabel?.font = .Body3_R14
    }
    
    func setConstraint() { }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StateButton {
    func setStyleState(styleState: ButtonStyleState) {
        self.styleState.accept(styleState)
    }
}

extension StateButton {
    // style
    func inactiveStyle() {
        self.layer.borderColor = Asset.Colors.gray4.color.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = Asset.Colors.white.color
        self.setTitleColor(Asset.Colors.black.color, for: .normal)
    }
    func fillStyle() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.backgroundColor = Asset.Colors.brandGreen.color
        self.setTitleColor( Asset.Colors.white.color, for: .normal)
    }
    func outlineStyle() {
        self.layer.borderColor = Asset.Colors.brandGreen.color.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = Asset.Colors.white.color
        self.setTitleColor(Asset.Colors.brandGreen.color, for: .normal)
    }
    func cancelStyle() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.backgroundColor = Asset.Colors.gray2.color
        self.setTitleColor(Asset.Colors.black.color, for: .normal)
    }
    func disableStyle() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0
        self.backgroundColor = Asset.Colors.gray6.color
        self.setTitleColor(Asset.Colors.gray3.color, for: .normal)
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
