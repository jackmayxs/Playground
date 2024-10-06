//
//  UIControl+Rx.swift
//
//  Created by Choi on 2023/5/15.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIControl {
    
    public var state: Observable<UIControl.State> {
        Observable.combineLatest(isEnabled, isSelected, isHighlighted)
            .withUnretained(base)
            .map(\.0.state)
            .startWith(base.state)
            .removeDuplicates
    }
    
    public var isHighlighted: ControlProperty<Bool> {
        let observeIsHighlighted = observe(\.isHighlighted, options: .live)
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isHighlighted in
            guard isHighlighted != control.isHighlighted else { return }
            control.isHighlighted = isHighlighted
        }
        return ControlProperty(values: observeIsHighlighted, valueSink: binder)
    }
    
    public var isSelected: ControlProperty<Bool> {
        /// 属性变化序列
        let observeIsSelected = observe(\.isSelected, options: .live)
            .withUnretained(base)
            .filter(\.0.blockIsSelectedEvent.isFalse)
            .map(\.1)
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isSelected in
            /// 确保值不同的时候才执行后续操作
            guard isSelected != control.isSelected else { return }
            /// 阻断事件发送
            control.blockIsSelectedEvent = true
            /// 设置新值
            control.isSelected = isSelected
            /// 之后恢复事件发送
            control.blockIsSelectedEvent = false
        }
        return ControlProperty(values: observeIsSelected, valueSink: binder)
    }
    
    public var isEnabled: ControlProperty<Bool> {
        let observeIsEnabled = observe(\.isEnabled, options: .live)
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isEnabled in
            guard isEnabled != control.isEnabled else { return }
            control.isEnabled = isEnabled
        }
        return ControlProperty(values: observeIsEnabled, valueSink: binder)
    }
}

extension UIControl {
    
    fileprivate var blockIsSelectedEvent: Bool {
        get {
            associated(Bool.self, self, Associated.blockIsSelectedEvent).or(false)
        }
        set {
            setAssociatedObject(self, Associated.blockIsSelectedEvent, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
