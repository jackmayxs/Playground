//
//  UIView+Rx.swift
//
//  Created by Choi on 2022/8/18.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    /// UIScrollView及其子类不可使用此属性, 否则会发生运行时错误
    var frame: Observable<CGRect> {
        observe(\.frame, options: [.initial, .new])
    }
    
    var intrinsicContentSize: Observable<CGSize> {
        didLayoutSubviews.map(\.intrinsicContentSize)
    }
    
    /// 是否横屏
    var isLandscape: Observable<Bool> {
        window.unwrapped.once.flatMap { window in
            NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
                .map { _ in
                    UIDevice.current.orientation
                }
                .filter(\.isValidInterfaceOrientation)
                .map(\.isLandscape)
                .distinctUntilChanged()
                .startWith(window.isLandscape)
        }
    }
    
    var window: Observable<UIWindow?> {
        didMoveToWindow.startWith(base.window)
    }
    
    var didMoveToWindow: Observable<UIWindow?> {
        methodInvoked(#selector(base.didMoveToWindow))
            .withUnretained(base)
            .map(\.0.window)
    }
    
    var willMoveToWindow: Observable<UIWindow?> {
        methodInvoked(#selector(base.willMove(toWindow:)))
            .map(\.first)
            .asOptional(UIWindow.self)
    }
    
    var willMoveToSuperView: Observable<UIView?> {
        methodInvoked(#selector(base.willMove(toSuperview:)))
            .map(\.first)
            .asOptional(UIView.self)
    }
    
    var removeFromSuperview: Observable<[Any]> {
        methodInvoked(#selector(base.removeFromSuperview))
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
