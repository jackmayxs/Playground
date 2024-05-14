//
//  UIGestureRecognizerPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/5/14.
//

import UIKit

extension UIGestureRecognizer.State {
    
    /// 用于过滤手指停止事件
    var isEnded: Bool {
        self == .ended
    }
}
