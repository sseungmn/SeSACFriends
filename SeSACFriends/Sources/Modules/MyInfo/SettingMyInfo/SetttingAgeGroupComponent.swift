//
//  SetttingAgeGroupComponent.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/03.
//

import UIKit
import MultiSlider
import RxSwift
import Network
import RxCocoa

class SettingAgeGroupComponent: View {
    let titleLable = UILabel().then { label in
        label.font = .Title4_R14
        label.textColor = Asset.Colors.black.color
        label.text = "상대방 연령대"
    }
    
    let rangeLabel = UILabel().then { label in
        label.font = .Title3_M14
        label.textColor = Asset.Colors.brandGreen.color
    }
    
    let rangeSlider = MultiSlider().then { slider in
        slider.tintColor = Asset.Colors.brandGreen.color
        slider.outerTrackColor = Asset.Colors.gray2.color
        slider.showsThumbImageShadow = false
        slider.orientation = .horizontal
        slider.trackWidth = 4
        slider.thumbCount = 2
        slider.minimumValue = 18
        slider.maximumValue = 65
        slider.thumbViews.forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.size.equalTo(22)
            }
        }
    }
    
    override func configure() {
        layer.masksToBounds = true
    }
    
    override func setConstraint() {
        snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(13)
        }
        addSubview(rangeLabel)
        rangeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(13)
        }
        addSubview(rangeSlider)
        rangeSlider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(snp.bottom).inset(18)
            make.width.equalToSuperview()
        }
    }
}

extension Reactive where Base: MultiSlider {
    var value: ControlProperty<[CGFloat]> {
        return base.rx.controlProperty(editingEvents: .valueChanged) { slider in
            slider.value
        } setter: { slider, value in
            slider.value = value
        }
    }
}
