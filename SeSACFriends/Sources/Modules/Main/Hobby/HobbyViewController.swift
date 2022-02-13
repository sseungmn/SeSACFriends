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
    
    override func bind() {
        let input = HobbyViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            itemSelected: mainView.hobbyCollectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        mainView.hobbyCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.collectionViewItems
            .bind(to: mainView.hobbyCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.error
            .emit(onNext: { [weak self] error in
                guard let hobbyCollectionError = error as? HobbyCollectionError else { return }
                switch hobbyCollectionError {
                case .already:
                    self?.mainView.makeToast("이미 등록된 취미입니다")
                case .overflowed:
                    self?.mainView.makeToast("취미를 더 이상 추가할 수 없습니다")
                }
            })
            .disposed(by: disposeBag)
    }
}
