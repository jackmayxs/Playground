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
        let observeIsSelected = observe(\.isSelected, options: .live)
        let binder = Binder(base, scheduler: MainScheduler.instance) { control, isSelected in
            guard isSelected != control.isSelected else { return }
            control.isSelected = isSelected
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
