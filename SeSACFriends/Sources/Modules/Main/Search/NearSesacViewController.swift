//
//  NearSesacViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/15.
//

import UIKit

class NearSesacViewController: ViewController {
    
    let emptyView = SearchEmptyView()
    let mainView = SearchView()
    
    override func loadView() {
        view = mainView
    }
    
    override func configure() {
        super.configure()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func bind() {
    }
}

extension NearSesacViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCardCell.reuseID) as? UserCardCell else { return UserCardCell() }
        cell.nearSesacStyle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCardCell else { return }
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            cell.userCard.isCardClosed.toggle()
            tableView.endUpdates()
        }
    }
}
