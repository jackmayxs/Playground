//
//  UIResponder+Rx.swift
//  KnowLED
//
//  Created by Choi on 2024/4/22.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIResponder {
    
    /// 监听touchesEnded方法调用
    var touchesEnded: Observable<[Any]> {
        methodInvoked(#selector(base.touchesEnded(_:with:)))
    }
}
