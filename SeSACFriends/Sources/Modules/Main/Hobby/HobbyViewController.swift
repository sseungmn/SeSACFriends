//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class HobbyViewController: ViewController, UICollectionViewDelegate {
    
    let recommends = ["아무거나", "Sesac", "코딩", "맛집탐방", "공원산책", "독서모임", "아무거나"]
    let data = ["다육이", "쓰레기줍기", "클라이밍", "달리기", "오일파스텔" ,"축구" ,"배드민턴", "달리기", "오일파스텔" ,"축구" ,"배드민턴", "테니스", "다육이", "쓰레기줍기"]
    let my = ["고구마", "감자", "무", "배추", "토마토", "오이", "당근" , "상추", "고추", "양파", "마늘"]
    
    let dataSource = HobbyDataSource.dataSource()
    
    let recommends_ = BehaviorRelay<[String]>(value: ["아무거나", "Sesac", "코딩", "맛집탐방", "공원산책", "독서모임", "아무거나"])
    let queued_ = BehaviorRelay<[String]>(value: ["다육이", "쓰레기줍기", "클라이밍", "달리기", "오일파스텔" ,"축구" ,"배드민턴", "달리기", "오일파스텔" ,"축구" ,"배드민턴", "테니스", "다육이", "쓰레기줍기"])
    let my_ = BehaviorRelay<[String]>(value: ["고구마", "감자", "무", "배추", "토마토", "오이", "당근" , "상추", "고추", "양파", "마늘"])
    lazy var sections: [HobbySection] = [
        .RecommendedHobbySection(items: self.recommends),
        .QueuedUsersHobbySection(items: self.data),
        .myHobbySection(items: self.my)
    ]
    
    let mainView = HobbyView()
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        super.configure()
        
//        mainView.hobbyCollectionView.delegate = self
//        mainView.hobbyCollectionView.dataSource = self
    }
    
    override func bind() {
        Observable.combineLatest(
            recommends_.asObservable(),
            queued_.asObservable(),
            my_.asObservable()
        ) { recommends, queued, my -> [HobbySection] in
            return [
                .RecommendedHobbySection(items: recommends),
                .QueuedUsersHobbySection(items: queued),
                .myHobbySection(items: my)
            ]
        }
            .bind(to: mainView.hobbyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        mainView.hobbyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        mainView.hobbyCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch indexPath.section {
                case 2:
                    // delete from my
                    var items = self.my_.value
                    items.remove(at: indexPath.row)
                    self.my_.accept(items)
                case 0:
                    // append to my
                    let item = self.recommends_.value[indexPath.row]
                    var target = self.my_.value
                    target.append(item)
                    self.my_.accept(target)
                case 1:
                    let item = self.queued_.value[indexPath.row]
                    var target = self.my_.value
                    target.append(item)
                    self.my_.accept(target)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}

struct HobbyDataSource {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<HobbySection> {
        return .init { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCell.reuseID, for: indexPath) as? HobbyCell else { return HobbyCell() }
            switch dataSource[indexPath.section] {
            case .RecommendedHobbySection:
                cell.setTitle(item)
                cell.recommendedHobbyStyle()
                return cell
            case .QueuedUsersHobbySection:
                cell.setTitle(item)
                cell.othersHobbyStyle()
                return cell
            case .myHobbySection:
                cell.setTitle(item)
                cell.myHobbyStyle()
                return cell
            }
        } configureSupplementaryView: { dataSource, collectionView, title, indexPath in
            debug(title: "supplementaryView", title)
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HobbyHeader.reuseID, for: indexPath) as? HobbyHeader else { return HobbyHeader() }
            switch dataSource[indexPath.section] {
            case .RecommendedHobbySection:
                header.setTitle(dataSource.sectionModels[indexPath.section].header)
                return header
            case .QueuedUsersHobbySection:
                header.frame = .zero
                return header
            case .myHobbySection:
                header.setTitle(dataSource.sectionModels[indexPath.section].header)
                return header
            }
        }
    }
            //        } moveItem: { <#CollectionViewSectionedDataSource<SectionModel>#>, sourceIndexPath, destinationIndexPath in
            //            <#code#>
            //        } canMoveItemAtIndexPath: { <#CollectionViewSectionedDataSource<SectionModel>#>, <#IndexPath#> in
            //            <#code#>
            //        }
}

enum HobbySection {
    case RecommendedHobbySection(items: [String])
    case QueuedUsersHobbySection(items: [String])
    case myHobbySection(items: [String])
}

extension HobbySection: SectionModelType {
    typealias Item = String
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
    
    var items: [Item] {
        switch self {
        case .RecommendedHobbySection(let items):
            return items
        case .QueuedUsersHobbySection(let items):
            return items
        case .myHobbySection(let items):
            return items
        }
    }
    
    var header: String {
        switch self {
        case .RecommendedHobbySection:
            return "지금 주변에는"
        case .myHobbySection:
            return "내가 하고 싶은"
        default:
            return ""
        }
    }
}

//// MARK: Delegate
//extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0: return recommends.count
//        case 1: return data.count
//        default: return my.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCell.reuseID, for: indexPath) as? HobbyCell else { return HobbyCell() }
//        switch indexPath.section {
//        case 0:
//            cell.recommendedHobbyStyle()
//            cell.setTitle(recommends[indexPath.row])
//        case 1:
//            cell.othersHobbyStyle()
//            cell.setTitle(data[indexPath.row])
//        default:
//            cell.myHobbyStyle()
//            cell.setTitle(my[indexPath.row])
//        }
//        return cell
//    }
//
//    // MARK: Set Section
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HobbyHeader.reuseID, for: indexPath) as? HobbyHeader else { return HobbyHeader() }
//        if indexPath.section == 0 {
//            header.setTitle("지금 주변에는")
//        } else if indexPath.section == 2 {
//            header.setTitle("내가 하고 싶은")
//        }
//        return header
//    }
//}
