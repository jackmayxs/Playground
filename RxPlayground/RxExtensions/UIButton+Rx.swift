//
//  UIButton+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/4.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    var tapButton: ControlEvent<Base> {
        let tappedButton = tap.withUnretained(base).map(\.0)
        return ControlEvent(events: tappedButton)
    }
    
    var normalTitle: Binder<String?> {
        title(for: .normal)
    }
    
    var normalImage: Binder<UIImage?> {
        image(for: .normal)
    }
    
    var isSelected: ControlProperty<Bool> {
        controlProperty(editingEvents: .touchUpInside) { button in
            button.isSelected
        } setter: { button, selected in
            button.isSelected = selected
        }
    }
    
    /// 限制按钮连续点击
    /// 时间:800毫秒
    var throttledTap: Observable<Void> {
        tap.throttle(.milliseconds(800), latest: false, scheduler: MainScheduler.instance)
    }
}
