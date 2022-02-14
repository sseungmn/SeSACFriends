//
//  SearchTabmanController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/11.
//

import UIKit
import Tabman
import Pageboy

class SearchTabmanController: TabmanViewController {
    private var vc = [NearSesacViewController(), RequestedSesacViewController()]
    
    let backButton = UIBarButtonItem(
        image: Asset.Assets.arrow.image,
        style: .plain,
        target: nil, action: nil
    )
    let stopSearchingButton = UIBarButtonItem(
        title: "찾기중단",
        style: .plain,
        target: nil, action: nil
    )
    
    let bar = TMBar.ButtonBar().then { bar in
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.buttons.customize { (button) in
            button.tintColor = Asset.Colors.gray6.color
            button.selectedTintColor = Asset.Colors.brandGreen.color
            button.font = .Title3_M14
        }
        bar.indicator.tintColor = Asset.Colors.brandGreen.color
        bar.indicator.weight = .light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.dataSource = self
    }
    
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "새싹 찾기"
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopSearchingButton
        stopSearchingButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.Title3_M14], for: .normal)
        addBar(bar, dataSource: self, at: .top)
    }
}

extension SearchTabmanController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vc.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vc[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var title: String!
        if index == 0 { title = "주변 새싹" }
        else if index == 1 { title = "받은 요청"}
        return TMBarItem(title: title)
    }
}
