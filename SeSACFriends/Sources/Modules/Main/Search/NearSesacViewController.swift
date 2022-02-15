//
//  NearSesacViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/15.
//

import UIKit
import RxSwift

class NearSesacViewController: ViewController, UITableViewDelegate {
    
    let emptyView = SearchEmptyView()
    let mainView = SearchView()
    let viewModel = NearSesacViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        super.configure()
    }
    
    override func bind() {
        let input = NearSesacViewModel.Input(
            viewWillAppearTrigger: rx.viewWillAppear.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        mainView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.nearSesacArray
            .drive(mainView.tableView.rx.items) { (tableView, _, element) in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCardCell.reuseID) as? UserCardCell else { return UserCardCell() }
                cell.nearSesacStyle()
                cell.fetchInfo(with: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { (owner, indexPath) in
                guard let cell = owner.mainView.tableView.cellForRow(at: indexPath) as? UserCardCell else { return }
                UIView.performWithoutAnimation {
                    owner.mainView.tableView.beginUpdates()
                    cell.userCard.isCardClosed.toggle()
                    owner.mainView.tableView.endUpdates()
                }
            }
            .disposed(by: disposeBag)
    }
}
