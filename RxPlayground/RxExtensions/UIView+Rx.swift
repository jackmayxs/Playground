//
//  UIView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    var didLayoutSubviews: Observable<Base> {
        base.rx.methodInvoked(#selector(base.layoutSubviews)).map { _ in base }
    }
    
    var superView: Observable<UIView> {
        base.rx.methodInvoked(#selector(base.didMoveToSuperview))
            .withUnretained(base)
            .map(\.0.superview)
            .startWith(base.superview)
            .compactMap(\.itself)
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
