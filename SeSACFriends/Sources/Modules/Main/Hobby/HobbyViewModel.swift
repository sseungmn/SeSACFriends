//
//  HobbyViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/13.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import RxDataSources

enum HobbyError: Error {
    case already, overflowed, invalidKeyword
}

class HobbyViewModel: ViewModel, ViewModelType {
    
    var curCoordinates = Observable<Coordinates>.just(
        (lat: SesacUserDefaults.targetLatitude,
         lng: SesacUserDefaults.targetLongitude)
        )
    
    let searchText = BehaviorRelay<String>(value: "")
    
    let recommendedHobby = BehaviorRelay<[String]>(value: [])
    let queuedUsersHobby = BehaviorRelay<[String]>(value: [])
    let myHobby = BehaviorRelay<[String]>(value: [])
    
    struct Input {
        var viewWillAppear: Observable<Bool>
        var textDidEndEditing: Observable<Void>
        var itemSelected: Observable<IndexPath>
        var searchButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let collectionViewItems: Observable<[HobbySection]>
        let pushSearchScene: Driver<Void>
        let prohibited: Driver<QueueError>
        let needGenderSelection: Driver<Void>
        let error: Driver<Error>
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
        
        // MARK: SesarchBar
        let isValid = searchText.asObservable()
            .distinctUntilChanged()
            .map(validate)
            .share()
        
        isValid
            .subscribe()
            .disposed(by: disposeBag)
        
        input.textDidEndEditing
            .withLatestFrom(isValid)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .bind(onNext: { (owner, hobbies) in
                var target = owner.myHobby.value
                guard target.count < 8 else {
                    owner.errorCollector.accept(HobbyError.overflowed)
                    return
                }
                for hobby in hobbies {
                    guard !target.contains(hobby) else {
                        owner.errorCollector.accept(HobbyError.already)
                        return
                    }
                    target.append(hobby)
                }
                owner.myHobby.accept(target)
                owner.searchText.accept("")
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
                        self.errorCollector.accept(HobbyError.overflowed)
                        return
                    }
                    if indexPath.section == 0 {
                        item = self.recommendedHobby.value[indexPath.row]
                    } else {
                        item = self.queuedUsersHobby.value[indexPath.row]
                    }
                    guard !target.contains(item) else {
                        self.errorCollector.accept(HobbyError.already)
                        return
                    }
                    target.append(item)
                }
                self.myHobby.accept(target)
            }
            .disposed(by: disposeBag)
        
        // MARK: Queue
        let postQueue = input.searchButtonTrigger.asObservable()
            .withLatestFrom(
                Observable.combineLatest(
                    curCoordinates,
                    myHobby.asObservable()
                )
            )
            .flatMap { (coor, hobby) -> Observable<Event<Void>> in
                let hobby: [String] = hobby.isEmpty ? ["Anything"] : hobby
                return QueueAPI.shared.postQueue(
                    lat: coor.lat,
                    long: coor.lng,
                    hf: hobby
                )
                    .asObservable()
                    .retryWithTokenIfNeeded()
                    .materialize()
            }
            .share()
        
        let pushSearchScene = postQueue.elements()
        
        postQueue.errors()
            .bind(to: errorCollector)
            .disposed(by: disposeBag)
        
        let prohibited = postQueue.errors()
            .compactMap { $0 as? QueueError }
            .filter { error in
                if case QueueError.penalty = error {
                    return true
                } else if case QueueError.banned = error {
                    
                    return true
                }
                return false
            }
        
        let needGenderSelection = postQueue.errors()
            .compactMap { $0 as? QueueError }
            .filter { error in
                if case QueueError.needGenderSelection = error { return true}
                return false
            }
            .mapToVoid()

        return Output(
            collectionViewItems: collectionViewItems,
            pushSearchScene: pushSearchScene.asDriverOnErrorJustComplete(),
            prohibited: prohibited.asDriverOnErrorJustComplete(),
            needGenderSelection: needGenderSelection.asDriverOnErrorJustComplete(),
            error: self.errorCollector.asDriverOnErrorJustComplete()
        )
    }
}

// MARK: SearchBar
extension HobbyViewModel {
    func validate(text: String) -> [String] {
        let keywords = text.components(separatedBy: " ")
        for keyword in keywords {
            guard 1 <= keyword.count && keyword.count <= 8 else {
                errorCollector.accept(HobbyError.invalidKeyword)
                return Array()
            }
        }
        return keywords
    }
}

// MARK: CollectionView DataSource
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
