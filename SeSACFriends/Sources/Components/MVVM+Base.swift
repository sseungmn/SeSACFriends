//
//  MVVM+Protocol.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import UIKit
import RxSwift
import RxRelay

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class ViewModel {
    var disposeBag = DisposeBag()
    var errorCollector = PublishRelay<Error>()
    
    init() {
        self.errorCollector
            .subscribe(onNext: { error in
                debug(title: "ERROR", error)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("Deinit \(String(describing: self))")
    }
}

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraint()
        bind()
    }
    
    func configure() { }
    func setConstraint() { }
    func bind() { }
}
