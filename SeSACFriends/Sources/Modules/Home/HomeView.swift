//
//  HomeView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import UIKit

class HomeView: View {
    
    let mapView = SesacMapView()
    
    let genderFilterView = GenderFilterView()
    
    let currentLocationButton = UIButton().then { button in
        button.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
        button.setImage(Asset.Assets.place.image, for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = Asset.Colors.black.color
        button.backgroundColor = .white
        
        button.layer.cornerRadius = 8
        button.setShadow()
    }
    
    let matchingStatusButton = MatchingStatusButton()
    
    override func setConstraint() {
        addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubview(genderFilterView)
        genderFilterView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        addSubview(currentLocationButton)
        currentLocationButton.snp.makeConstraints { make in
            make.top.equalTo(genderFilterView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
        addSubview(matchingStatusButton)
        matchingStatusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
