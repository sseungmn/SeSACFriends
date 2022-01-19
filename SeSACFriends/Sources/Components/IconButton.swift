//
//  IconButton.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/19.
//

import UIKit

import RxSwift
import RxCocoa

final class IconStateButton: StateButton {
    private let buttonTitleLabel = UILabel().then { label in
        label.font = .Title4_R14
    }
    private let closeIconView = UIImageView(image: UIImage.closeSmall)
    
    private var isIconHidden = PublishRelay<Bool>()
    private var title = PublishRelay<String>()
    
    convenience init(isIconHidden: Bool) {
        self.init(frame: .zero)
        self.setIconHidden(isHidden: isIconHidden)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func bind() {
        super.bind()
        
        title
            .bind(to: buttonTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        isIconHidden
            .subscribe { isIconHidden in
                self.updateContraintWithIcon(isHidden: isIconHidden)
            }
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()

        self.sizeToFit()
        styleState.accept(.cancel)
    }
    
    override func setConstraint() {
        super.setConstraint()
        
        addSubview(buttonTitleLabel)
        addSubview(closeIconView)
        buttonTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(7)
            make.trailing.equalTo(closeIconView.snp.leading).offset(-4)
        }
        closeIconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateContraintWithIcon(isHidden: Bool) {
        switch isHidden {
        case true:
            closeIconView.isHidden = true
            buttonTitleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview().inset(7)
                make.trailing.equalToSuperview().inset(16)
            }
        case false:
            closeIconView.isHidden = false
            buttonTitleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview().inset(7)
                make.trailing.equalTo(closeIconView.snp.leading).offset(-4)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: BehaviorRelay Setter
extension IconStateButton {
    func setTitle(title: String?) {
        self.title.accept(title ?? "")
    }
    func setIconHidden(isHidden: Bool) {
        self.isIconHidden.accept(isHidden)
    }
}
