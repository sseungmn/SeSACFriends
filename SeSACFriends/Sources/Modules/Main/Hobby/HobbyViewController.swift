//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit

class HobbyViewController: ViewController {
    
    let recommends = ["아무거나", "Sesac", "코딩", "맛집탐방", "공원산책", "독서모임", "아무거나"]
    let data = ["다육이", "쓰레기줍기", "클라이밍", "달리기", "오일파스텔" ,"축구" ,"배드민턴", "달리기", "오일파스텔" ,"축구" ,"배드민턴", "테니스", "다육이", "쓰레기줍기"]
    let my = ["고구마", "감자", "무", "배추", "토마토", "오이", "당근" , "상추", "고추", "양파", "마늘"]
    
    let mainView = HobbyView()
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        mainView.hobbyCollectionView.delegate = self
        mainView.hobbyCollectionView.dataSource = self
    }
}

extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return recommends.count
        case 1: return data.count
        default: return my.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCell.reuseID, for: indexPath) as? HobbyCell else { return HobbyCell() }
        switch indexPath.section {
        case 0:
            cell.recommendedHobbyStyle()
            cell.setTitle(recommends[indexPath.row])
        case 1:
            cell.othersHobbyStyle()
            cell.setTitle(data[indexPath.row])
        default:
            cell.myHobbyStyle()
            cell.setTitle(my[indexPath.row])
        }
        return cell
    }
    
    // MARK: Set Section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HobbyHeader.reuseID, for: indexPath) as? HobbyHeader else { return HobbyHeader() }
        if indexPath.section == 0 {
            header.setTitle("지금 주변에는")
        } else if indexPath.section == 2 {
            header.setTitle("내가 하고 싶은")
        }
        return header
    }
}
