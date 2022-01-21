//
//  TextField+Component.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/20.
//

import UIKit

import RxSwift
import RxRelay

enum TextFieldStyleState: Int {
    case normal, focus, disable, error, success
}

class StateTextField: UITextField, StyleStateChangebale {
    
    // StaeChangeable Conformance
    typealias StyleState = TextFieldStyleState
    var styleState = PublishRelay<TextFieldStyleState>()
    var disposeBag = DisposeBag()
    
    // Underline
    let underline = CALayer()
    let lineHeight: CGFloat = 1.0
    override func draw(_ rect: CGRect) {
        underline.frame = CGRect(
            x: 0,
            y: self.frame.size.height - lineHeight,
            width: self.frame.size.width,
            height: self.frame.size.height
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        configure()
        setConstraint()
    }
    
    func bind() {
        styleState
            .bind(to: self.rx.styleState)
            .disposed(by: disposeBag)
        self.rx.controlEvent(.editingDidBegin)
            .map { TextFieldStyleState.focus }
            .bind(to: styleState)
            .disposed(by: disposeBag)
        self.rx.controlEvent(.editingDidEnd)
            .map { TextFieldStyleState.normal }
            .bind(to: styleState)
            .disposed(by: disposeBag)
    }
    
    func configure() {
        font = .Title4_R14
        underline.borderWidth = lineHeight
        setStyleState(styleState: .normal)
    }
    
    func setConstraint() {
        layer.addSublayer(underline)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 13, dy: 12)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 13, dy: 12)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 13, dy: 12)
    }
    override func endEditing(_ force: Bool) -> Bool {
        super.endEditing(force)
        if let superview = superview {
            superview.endEditing(true)
        }
        return force
    }
}

// MARK: Setter
extension StateTextField {
    func setStyleState(styleState: TextFieldStyleState) {
        self.styleState.accept(styleState)
    }
    func setPlaceholder(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.Title4_R14,
                .foregroundColor: Asset.Colors.gray7.color
            ]
        )
    }
    private func setUnderlineColor(color: CGColor?) {
        self.underline.borderColor = color
    }
    private func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
}

// MARK: Style
extension StateTextField {
    fileprivate func normalStyle() {
        // underline color
        setUnderlineColor(color: Asset.Colors.gray3.color.cgColor)
        // background color
        setBackgroundColor(color: Asset.Colors.white.color)
    }
    fileprivate func focusStyle() {
        setUnderlineColor(color: Asset.Colors.focus.color.cgColor)
        setBackgroundColor(color: Asset.Colors.white.color)
    }
    fileprivate func disableStyle() {
        setUnderlineColor(color: nil)
        setBackgroundColor(color: Asset.Colors.gray3.color)
    }
    fileprivate func errorStyle() {
        setUnderlineColor(color: Asset.Colors.error.color.cgColor)
        setBackgroundColor(color: Asset.Colors.white.color)
        // infoLabel text color
    }
    fileprivate func successStyle() {
        setUnderlineColor(color: Asset.Colors.success.color.cgColor)
        setBackgroundColor(color: Asset.Colors.white.color)
        // infoLabel text color
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
