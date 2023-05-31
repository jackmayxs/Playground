//
//  UIView+Rx.swift
//
//  Created by Choi on 2022/8/18.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    var window: Observable<UIWindow?> {
        didMoveToWindow.startWith(base.window)
    }
    
    var didMoveToWindow: Observable<UIWindow?> {
        methodInvoked(#selector(base.didMoveToWindow))
            .withUnretained(base)
            .map(\.0.window)
    }

    var didLayoutSubviews: Observable<Base> {
        methodInvoked(#selector(base.layoutSubviews))
            .withUnretained(base)
            .map(\.0)
    }
    
    var superView: Observable<UIView?> {
        methodInvoked(#selector(base.didMoveToSuperview))
            .withUnretained(base)
            .map(\.0.superview)
            .startWith(base.superview)
            .distinctUntilChanged()
    }
    
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
