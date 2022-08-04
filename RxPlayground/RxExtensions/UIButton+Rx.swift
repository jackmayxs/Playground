//
//  UIButton+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/4.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    /// 限制按钮连续点击
    /// 时间:800毫秒
    var throttledTap: Observable<Void> {
        tap.throttle(.milliseconds(800), latest: false, scheduler: MainScheduler.instance)
    }
}
