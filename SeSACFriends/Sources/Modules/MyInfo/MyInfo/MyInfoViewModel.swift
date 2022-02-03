//
//  MyinfoViewModel.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/01.
//

import UIKit
import RxSwift
import RxCocoa

class MyInfoViewModel: ViewModel, ViewModelType {
    
    private let myInfoTitleCellTap = PublishRelay<Void>()
    
    struct Input {}
    struct Output {
        let pushSettingMyInfoViewController: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(pushSettingMyInfoViewController: myInfoTitleCellTap.asDriverOnErrorJustComplete())
    }
    
    let myInfoSection = [
        MyInfoSectionItem.notice,
        MyInfoSectionItem.faq,
        MyInfoSectionItem.qna,
        MyInfoSectionItem.settingAlarm,
        MyInfoSectionItem.permit
    ]
    
    func didSelectRowAt(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            debug(title: "MyInfoTitleCell", indexPath.row)
            myInfoTitleCellTap.accept(())
        default:
            debug(title: "MyInfoCell", indexPath.row)
        }
    }
    
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return myInfoSection.count
        }
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 96
        default:
            return 74
        }
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTitleCell.reuseID) as? MyInfoTitleCell else { return MyInfoCell() }
            cell.nickLabel.text = AuthUserDefaults.nick
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoCell.reuseID) as? MyInfoCell else { return MyInfoCell() }
            debug(title: "cell(\(indexPath.row))", myInfoSection[indexPath.row])
            cell.leftImageView.image = myInfoSection[indexPath.row].image
            cell.titleLabel.text = myInfoSection[indexPath.row].title
            return cell
        }
    }
    
}
