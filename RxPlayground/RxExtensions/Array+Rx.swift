//
//  Array+Rx.swift
//  RxPlayground
//
//  Created by Major on 2022/4/20.
//

import RxSwift
import RxCocoa

extension Array where Element: ObservableConvertibleType {
    var merged: Observable<Element.Element> {
        Observable.from(self).merge()
    }
}

// MARK: - __________ UIButton+Rx __________
extension Observable where Element: UIButton {
    func matches(button: UIButton) -> Observable<Bool> {
        map { $0 == button }
    }
}

extension Array where Element: UIButton {
    var selectedButton: Observable<Element> {
        let buttonObservables = map { button in
            button.rx.tap.map { button }
        }
        return Observable.from(buttonObservables).merge()
    }
}
