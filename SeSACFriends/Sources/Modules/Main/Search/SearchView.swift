//
//  SearchView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/14.
//

import UIKit

final class SearchView: View {
    let emptyView = SearchEmptyView()
    let tableView = UITableView()
    
    override func configure() {
        super.configure()
        
        tableView.register(UserCardCell.self, forCellReuseIdentifier: UserCardCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        tableView.separatorStyle = .none
    }
    
    override func setConstraint() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class UserCardCell: UITableViewCell {
    let userCard = UserCardView(withHobby: true)
    
    let button = UIButton().then { button in
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .Title3_M14
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setContraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectionStyle = .none
    }

    private func setContraint() {
        contentView.addSubview(userCard)
        userCard.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.top.trailing.equalToSuperview().inset(12)
        }
    }
}

extension UserCardCell {
    func nearSesacStyle() {
        button.setTitle("요청하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Asset.Colors.error.color
    }
    
    func requestedSesacStyle() {
        button.setTitle("수락하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Asset.Colors.success.color
    }
}

extension UserCardCell {
    func fetchInfo(with user: QueuedUser) {
        userCard.fetchInfo(with: user)
    }
}
