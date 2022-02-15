//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class HobbyViewController: ViewController, UIScrollViewDelegate {
    
    let dataSource = HobbyDataSource.dataSource()
    let searchBar = UISearchBar().then { searchBar in
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.searchTextField.leftView?.tintColor = .systemGray
        searchBar.searchTextField.textColor = Asset.Colors.black.color
    }
    let mainView = HobbyView()
    var viewModel = HobbyViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        self.navigationItem.titleView = searchBar
    }
    
    override func bind() {
        let input = HobbyViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            textDidEndEditing: searchBar.rx.searchButtonClicked.asObservable(),
            itemSelected: mainView.hobbyCollectionView.rx.itemSelected.asObservable(),
            searchButtonTrigger: mainView.sesacSearchButton.rx.tap.debug("buttonTrigger").asObservable()
        )
        let output = viewModel.transform(input: input)
        
        mainView.hobbyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.textInput <-> viewModel.searchText
        
        output.collectionViewItems
            .bind(to: mainView.hobbyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.error
            .compactMap { $0 as? HobbyError }
            .drive(onNext: { [weak self] hobbyError in
                switch hobbyError {
                case .already:
                    self?.mainView.makeToast("이미 등록된 취미입니다")
                case .overflowed:
                    self?.mainView.makeToast("취미를 더 이상 추가할 수 없습니다")
                case .invalidKeyword:
                    self?.mainView.makeToast("최소 한 자이상, 최대 8글자까지 작성 가능합니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.pushSearchScene
            .drive(onNext: { [weak self] _ in
                self?.push(viewController: SearchTabmanController())
            })
            .disposed(by: disposeBag)
        
        output.prohibited
            .drive(onNext: { [weak self] error in
                if case QueueError.penalty(let level) = error {
                    self?.mainView.makeToast("약속 취소 패널티로, \(level)분동안 이용하실 수 없습니다")
                } else if case QueueError.banned = error {
                    self?.mainView.makeToast("신고가 누적되어 이용하실 수 없습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.needGenderSelection
            .drive { [weak self] _ in
                self?.tabBarController?.selectedIndex = 2
                guard let nav = self?.tabBarController?.selectedViewController as? UINavigationController else {
                    return
                }
                let targetViewController = SettingMyInfoViewController()
                targetViewController.hidesBottomBarWhenPushed = true
                targetViewController.view.makeToast("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!")
                nav.pushViewController(targetViewController, animated: false)
            }
            .disposed(by: disposeBag)
        
        // Keyboard
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                self.mainView.updateButtonY(with: height)
            })
            .disposed(by: disposeBag)

        RxKeyboard.instance.isHidden
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mainView.updateButtonY(with: 0)
            })
            .disposed(by: disposeBag)
    }
}
