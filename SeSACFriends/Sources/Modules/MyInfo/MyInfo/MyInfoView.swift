//
//  MyinfoView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import UIKit
import Then
import SnapKit

class MyInfoView: View {
    let tableView = UITableView().then { tableView in
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 17)
        tableView.isScrollEnabled = false
    }
    
    override func setConstraint() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
