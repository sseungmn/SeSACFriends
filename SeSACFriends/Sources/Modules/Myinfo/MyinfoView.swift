//
//  MyinfoView.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import UIKit
import Then
import SnapKit

class MyinfoView: View {
    let tableView = UITableView()
    
    override func setConstraint() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
