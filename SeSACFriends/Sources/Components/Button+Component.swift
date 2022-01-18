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
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { state in
                    print(state)
                    self.changeStyle(state: state)
                })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeStyle(state: ButtonStyleState) {
        switch state {
        case .inactive:
            self.layer.borderColor = UIColor.gray4.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = .customWhite
            self.setTitleColor(.customBlack, for: .normal)
        case .fill:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = .brandGreen
            self.setTitleColor(.customWhite, for: .normal)
        case .outline:
            self.layer.borderColor = UIColor.brandGreen.cgColor
            self.layer.borderWidth = 1
            self.backgroundColor = .customWhite
            self.setTitleColor(.brandGreen, for: .normal)
        case .cancel:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = .gray2
            self.setTitleColor(.customBlack, for: .normal)
        case .disable:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = .gray6
            self.setTitleColor(.gray3, for: .normal)
        }
    }
}

//extension Reactive where Base: StateButton {
//    var styleState: ControlProperty<ButtonStyleState> {
//        return base.rx.controlProperty(
//            editingEvents:  [.allEvents],
//            getter: { stateButton in
//                stateButton.styleState
//            },
//            setter: { stateButton, value in
//                if stateButton.styleState != value {
//                    stateButton.styleState = value
//                }
//            }
//        )
//    }
//}
