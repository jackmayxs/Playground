//
//  UIView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    var isVisible: Infallible<Bool> {
        let selector = #selector(base.didMoveToWindow)
        return methodInvoked(selector)
            .withUnretained(base)
            .map(\.0.window)
            .map(\.isValid)
            .observe(on: MainScheduler.instance)
            .asInfallible(onErrorJustReturn: false)
    }
}
