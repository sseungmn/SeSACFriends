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
        debug(title: "Deinit", String(describing: self))
    }
}

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraint()
        bind()
    }
    
    func configure() {}
    func setConstraint() {}
    func bind() {}
    
    deinit {
        debug(title: "Deinit", String(describing: self))
    }
}

class View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    func setConstraint() {}
    
}

class ReactiveView: View {
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {}
}
