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
    
    let year = PublishRelay<Int?>()
    let month = PublishRelay<Int?>()
    let day = PublishRelay<Int?>()
    
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
        mainView.yearComponentView.textField.becomeFirstResponder()
    }
    
    func bind() {
        let calendar = Calendar.current
        
        mainView.datePicker.rx.date
            .map { calendar.dateComponents([.year], from: $0).year }
            .bind(to: year)
            .disposed(by: disposeBag)
        mainView.datePicker.rx.date
            .map { calendar.dateComponents([.month], from: $0).month }
            .bind(to: month)
            .disposed(by: disposeBag)
        mainView.datePicker.rx.date
            .map { calendar.dateComponents([.day], from: $0).day }
            .bind(to: day)
            .disposed(by: disposeBag)
        
        let yearObservable = year.asObservable()
            .compactMap { $0 }
        yearObservable
            .map { String($0) }
            .bind(to: self.mainView.yearComponentView.textField.rx.text)
            .disposed(by: disposeBag)
        yearObservable
            .map { _ in Void() }
            .bind(to: self.mainView.yearComponentView.textField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        let monthObservable = month.asObservable()
            .compactMap { $0 }
        monthObservable
            .map { String($0) }
            .bind(to: self.mainView.monthComponentView.textField.rx.text)
            .disposed(by: disposeBag)
        monthObservable
            .map { _ in Void() }
            .bind(to: self.mainView.monthComponentView.textField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        let dayObservable = day.asObservable()
            .compactMap { $0 }
        dayObservable
            .map { String($0) }
            .bind(to: self.mainView.dayComponentView.textField.rx.text)
            .disposed(by: disposeBag)
        dayObservable
            .map { _ in Void() }
            .bind(to: self.mainView.dayComponentView.textField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .subscribe { [weak self] _ in
                self?.push(viewController: EmailViewController())
            }
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UITextField {
    var becomeFirstResponder: Binder<Void> {
        return Binder(self.base) { textFeild, _ in
            textFeild.becomeFirstResponder()
        }
    }
}
