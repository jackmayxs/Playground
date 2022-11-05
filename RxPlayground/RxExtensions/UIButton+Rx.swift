//
//  UIButton+Rx.swift
//  zeniko
//
//  Created by Choi on 2022/8/4.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    var normalImage: ControlProperty<UIImage?> {
        controlProperty(editingEvents: .allTouchEvents) { button in
            button.image(for: .normal)
        } setter: { button, newImage in
            button.setImage(newImage, for: .normal)
        }
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
