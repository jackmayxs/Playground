//
//  UIView+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    
    var isVisible: Observable<Bool> {
        let selector = #selector(UIView.didMoveToWindow)
        return methodInvoked(selector)
            .withUnretained(base)
            .map(\.0.window)
            .map { window in
                window != nil
            }
    }
}
