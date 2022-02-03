//
//  OnboardingViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/03.
//

import UIKit

class OnboardingViewController: ViewController {
    let descriptionLabel = UILabel().then { label in
        label.font = FontFamily.NotoSansKR.medium.font(size: 24)
        label.text = "위치 기반으로 빠르게\n주위 친구를 확인"
        label.textAlignment = .center
        label.textColor = Asset.Colors.black.color
        label.numberOfLines = 2
    }
    
    let imageView = UIImageView().then { imageView in
        imageView.image = Asset.Assets.onboardingImg1.image
    }
    
    let startButton = StateButton().then { button in
        button.setStyleState(styleState: .fill)
        button.setTitle("시작하기", for: .normal)
    }
    
    override func configure() {
        view.backgroundColor = .white
    }
    
    override func setConstraint() {
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.4)
            make.centerX.equalToSuperview()
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.0)
            make.centerX.equalToSuperview()
        }
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
    
    override func bind() {
        startButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                owner.makeRoot(viewController: PhoneNumberViewController())
            }
            .disposed(by: disposeBag)
    }
}
