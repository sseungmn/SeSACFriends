//
//  MyinfoViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import UIKit
import RxSwift
import RxCocoa

class MyInfoViewController: ViewController {
    
    let mainView = MyInfoView()
    let viewModel = MyInfoViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
    }
    
    override func bind() {
        let output = viewModel.transform(input: MyInfoViewModel.Input())
        output.pushSettingMyInfoViewController
            .drive { [weak self] _ in
                self?.push(viewController: SettingMyInfoViewController())
            }
            .disposed(by: disposeBag)
    }
}

extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func delegate() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(MyInfoCell.self, forCellReuseIdentifier: MyInfoCell.reuseID)
        mainView.tableView.register(MyInfoTitleCell.self, forCellReuseIdentifier: MyInfoTitleCell.reuseID)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRowAt(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
}
