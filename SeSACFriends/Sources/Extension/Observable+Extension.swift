//
//  Observable+Extension.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/01/27.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

// From RxSwiftExt
extension ObservableType where Element: EventConvertible {

    /**
     Returns an observable sequence containing only next elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func elements() -> Observable<Element.Element> {
        return compactMap { $0.event.element }
    }

    /**
     Returns an observable sequence containing only error elements from its input
     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
     */
    public func errors() -> Observable<Swift.Error> {
        return compactMap { $0.event.error }
    }
}

infix operator <-> : DefaultPrecedence

/**
 Two way binding operator between control property and relay
 
 ### Reference
 [RxSwift/RxExample](https://github.com/ReactiveX/RxSwift/blob/main/RxExample/RxExample/Operators.swift)
 */
func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument

    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }

    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }

    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }

    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

@discardableResult
func <-> <Base>(textInput: TextInput<Base>, variable: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] value in
            guard let base = base else {
                return
            }

            let nonMarkedTextValue = nonMarkedText(base)

            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with

             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }

             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.accept(nonMarkedTextValue)
            }
            }, onCompleted: {
                bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}

@discardableResult
func <-> <T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }

    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { value in
            variable.accept(value)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}
