//
//  HobbyViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit
import RxSwift
import RxCocoa

class HobbyViewController: ViewController, UICollectionViewDelegate {
    
    let dataSource = HobbyDataSource.dataSource()
    let searchBar = UISearchBar().then { searchBar in
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.searchTextField.leftView?.tintColor = .systemGray
        searchBar.searchTextField.textColor = Asset.Colors.black.color
    }
    let mainView = HobbyView()
    var viewModel: HobbyViewModel!
    
    init(viewModel: HobbyViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            itemSelected: mainView.hobbyCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        mainView.hobbyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        searchBar.searchTextField.rx.textInput <-> viewModel.searchText
        
        output.collectionViewItems
            .bind(to: mainView.hobbyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let hobbyError = error as? HobbyError else { return }
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
    }
}
