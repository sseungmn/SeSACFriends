//
//  Rx+ServiceExtension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/31.
//

import Foundation
import RxSwift
import RxCocoa

public extension ObservableType {
    /// Tries to refresh auth token on 401 errors and retry the request.
    /// If the refresh fails, the signal errors.
    func retryWithTokenIfNeeded() -> Observable<Element> {
        return retry { errorObservable -> Observable<Void> in
            return Observable.zip(
                errorObservable
                    .compactMap { $0 as? APIError }
                    .filter { $0 == APIError.firebaseTokenError },
                Observable.range(start: 1, count: 3),
                resultSelector: { $1 }
            )
                .flatMap { _ in // 범위가 3인 옵져버블과 묶어서 3번만 수행하게 한다.
                    return Firebase.shared.token()
                        .asObservable()
                        .flatMapLatest { _ in
                            CommonAPI.shared.refreshFCMtoken()
                                .asObservable()
                                .mapToVoid()
                        }
                }
        }
    }
}
