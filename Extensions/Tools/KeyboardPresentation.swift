//
//  KeyboardPresentation.swift
//  zeniko
//
//  Created by Choi on 2022/10/20.
//

import UIKit

struct KeyboardPresentation {
    let state: State
    let fromRect: CGRect
    let toRect: CGRect
    let animationDuration: TimeInterval
    let animationCurve: UIView.AnimationCurve
    init?(state: State, _ notification: Notification) {
        self.state = state
        
        guard let userInfo = notification.userInfo else { return nil }
        
        /// NSValue of CGRect
        guard let keyboardFrameBegin = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return nil }
        self.fromRect = keyboardFrameBegin.cgRectValue
        
        /// NSValue of CGRect
        guard let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
        self.toRect = keyboardFrameEnd.cgRectValue
        
        /// NSNumber of double
        guard let keyboardAnimationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
        self.animationDuration = keyboardAnimationDuration.doubleValue
        
        /// NSNumber of NSUInteger (UIViewAnimationCurve)
        guard
            let keyboardAnimationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let animationCurve = UIView.AnimationCurve(rawValue: keyboardAnimationCurve.intValue)
        else {
            return nil
        }
        self.animationCurve = animationCurve
    }
}

extension KeyboardPresentation {
    enum State {
        case presenting
        case dismissing
    }
}

extension KeyboardPresentation {
    
    /// 根据键盘显示/隐藏调整相应父视图的坐标
    /// - Parameter closeSubview: 父视图的直接子视图(superview.subviews contains closeSubview)
    /// 注: 通过调整父视图的bounds属性实现子视图整体上移,以达到避免键盘遮挡的问题
    func adjustBoundsOfSuperviewIfNeeded(closeSubview: UIView?) {
        guard let closeSubview else { return }
        guard let superview = closeSubview.superview else { return }
        switch state {
        case .presenting:
            /// 键盘顶部间距
            let padding = 30.0
            /// 键盘顶部的Y值 - 键盘顶部间距
            let keyboardTolerance = toRect.minY - padding
            let extraPadding = closeSubview.frame.maxY - keyboardTolerance
            if extraPadding > 0 {
                superview.bounds.origin.y = extraPadding
            }
        case .dismissing:
            superview.bounds.origin.y = 0
        }
    }
}
