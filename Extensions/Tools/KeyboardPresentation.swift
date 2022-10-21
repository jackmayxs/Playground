//
//  KeyboardPresentation.swift
//  zeniko
//
//  Created by Choi on 2022/10/20.
//

import UIKit

struct KeyboardPresentation {
    enum State {
        case presenting
        case dismissing
    }
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
