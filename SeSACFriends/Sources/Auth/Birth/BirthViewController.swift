//
//  BirthViewController.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/21.
//

import UIKit

import FirebaseAuth
import RxCocoa
import RxSwift
import SnapKit
import Then

class BirthViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let dateComponent = PublishRelay<DateComponents>()
    
    let mainView = BirthView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func configure() {
        mainView.yearTextField.becomeFirstResponder()
    }
    
    func bind() {
        let calendar = Calendar.current
        mainView.datePicker.rx.date
            .subscribe { date in
                guard let date = date.element else { return }
                let dateComponenets = calendar.dateComponents([.year, .month, .day], from: date)
                guard let year = dateComponenets.year,
                      let month = dateComponenets.month,
                      let day = dateComponenets.day else { return }
                 
                    self.mainView.yearTextField.text = String(year)
                    self.mainView.monthTextField.text = String(month)
                    self.mainView.dayTextField.text = String(day)
            }
            .disposed(by: disposeBag)

        mainView.yearTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { yearString in
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.mainView.datePicker.date)
                dateComponents.year = Int(yearString)
                guard let date = calendar.date(from: dateComponents) else { return }
                self.mainView.datePicker.date = date
            })
            .disposed(by: disposeBag)
        
        mainView.monthTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { monthString in
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.mainView.datePicker.date)
                dateComponents.month = Int(monthString)
                guard let date = calendar.date(from: dateComponents) else { return }
                self.mainView.datePicker.date = date
            })
            .disposed(by: disposeBag)
        mainView.dayTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { dayString in
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.mainView.datePicker.date)
                dateComponents.day = Int(dayString)
                guard let date = calendar.date(from: dateComponents) else { return }
                self.mainView.datePicker.date = date
            })
            .disposed(by: disposeBag)
    }
}
