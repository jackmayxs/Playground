//
//  UIControl+Rx.swift
//  KnowLED
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
            .startWith(.normal)
            .distinctUntilChanged()
    }
    
    public var isHighlighted: ControlProperty<Bool> {
        let observeIsHighlighted = base.rx.observe(\.isHighlighted, options: [.initial, .new])
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isHighlighted in
            guard isHighlighted != control.isHighlighted else { return }
            control.isHighlighted = isHighlighted
        }
        return ControlProperty(values: observeIsHighlighted, valueSink: binder)
    }
    
    public var isSelected: ControlProperty<Bool> {
        let observeIsSelected = base.rx.observe(\.isSelected, options: [.initial, .new])
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isSelected in
            guard isSelected != control.isSelected else { return }
            control.isSelected = isSelected
        }
        return ControlProperty(values: observeIsSelected, valueSink: binder)
    }
    
    public var isEnabled: ControlProperty<Bool> {
        let observeIsEnabled = base.rx.observe(\.isEnabled, options: [.initial, .new])
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isEnabled in
            guard isEnabled != control.isEnabled else { return }
            control.isEnabled = isEnabled
        }
        return ControlProperty(values: observeIsEnabled, valueSink: binder)
    }
}
