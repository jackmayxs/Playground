//
//  DispatchTimeIntervalPlus.swift
//  KnowLED
//
//  Created by Choi on 2024/7/19.
//

import Foundation

extension DispatchTimeInterval {
    
    /// 关联值 | 返回相应的秒/毫秒等值
    var associatedValue: Int {
        switch self {
        case .seconds(let seconds):
            seconds
        case .milliseconds(let milliseconds):
            milliseconds
        case .microseconds(let microseconds):
            microseconds
        case .nanoseconds(let nanoseconds):
            nanoseconds
        default:
            0
        }
    }
}
