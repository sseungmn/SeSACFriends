//
//  HobbyViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/13.
//

import Foundation
import NMapsMap
import RxSwift
import RxCocoa
import RxDataSources

enum HobbyCollectionError: Error {
    case already, overflowed
}

class HobbyViewModel: ViewModel, ViewModelType {
    
    var curCoordinates: Observable<NMGLatLng>!
    
    let recommendedHobby = BehaviorRelay<[String]>(value: [])
    let queuedUsersHobby = BehaviorRelay<[String]>(value: [])
    let myHobby = BehaviorRelay<[String]>(value: [])
    
    init(curCoordinates: NMGLatLng) {
        super.init()
        self.curCoordinates = Observable.just(curCoordinates)
    }
    
    struct Input {
        var viewWillAppear: Observable<Bool>
        var itemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let collectionViewItems: Observable<[HobbySection]>
        let error: Signal<Error>
    }
    
    func transform(input: Input) -> Output {
        
        let onqueue = input.viewWillAppear.asObservable()
            .withLatestFrom(curCoordinates)
            .flatMap { coor in
                QueueAPI.shared.onqueue(lat: coor.lat, long: coor.lng)
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        onqueue.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        onqueue.elements()
            .subscribe(onNext: { [weak self] onqueue in
                self?.recommendedHobby.accept(onqueue.fromRecommend)
                var hobbyArray: [String] = []
                (onqueue.fromQueueDB + onqueue.fromQueueDBRequested).forEach { queuedUser in
                    hobbyArray.append(
                        contentsOf: queuedUser.hf.filter { !hobbyArray.contains($0) }
                    )
                }
                self?.queuedUsersHobby.accept(hobbyArray)
            })
            .disposed(by: disposeBag)
        
        // MARK: CollectionView
        let collectionViewItems = Observable.combineLatest(
            recommendedHobby.asObservable(),
            queuedUsersHobby.asObservable(),
            myHobby.asObservable()
        ) { recommends, queued, my -> [HobbySection] in
            return [
                .RecommendedHobbySection(items: recommends),
                .QueuedUsersHobbySection(items: queued),
                .myHobbySection(items: my)
            ]
        }
        
        input.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                var target = self.myHobby.value
                if indexPath.section == 2 {
                    target.remove(at: indexPath.row)
                } else {
                    var item: String
                    guard target.count < 8 else {
                        self.errorCollector.accept(HobbyCollectionError.overflowed)
                        return
                    }
                    if indexPath.section == 0 {
                        item = self.recommendedHobby.value[indexPath.row]
                    } else {
                        item = self.queuedUsersHobby.value[indexPath.row]
                    }
                    guard !target.contains(item) else {
                        self.errorCollector.accept(HobbyCollectionError.already)
                        return
                    }
                    target.append(item)
                }
                self.myHobby.accept(target)
            }
            .disposed(by: disposeBag)
        
        return Output(
            collectionViewItems: collectionViewItems,
            error: self.errorCollector.asSignal()
        )
    }
}

struct HobbyDataSource {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<HobbySection> {
        return .init { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HobbyCell.reuseID,
                for: indexPath
            ) as? HobbyCell else { return HobbyCell() }
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
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HobbyHeader.reuseID,
                for: indexPath
            ) as? HobbyHeader else { return HobbyHeader() }
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
