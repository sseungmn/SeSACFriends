//
//  MVVM+Protocol.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/23.
//

import UIKit
import RxSwift
import RxRelay

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    var errorCollector: PublishRelay<Error> { get set }
    
    func transform(input: Input) -> Output
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
