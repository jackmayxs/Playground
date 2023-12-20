//
//  PercentClip.swift
//  KnowLED
//
//  Created by Choi on 2023/12/20.
//

import Foundation

struct PercentClip<T: BinaryFloatingPoint> {
    let lower: T?
    let upper: T?
    
    init(lower: T?, upper: T?) {
        self.lower = lower.flatMap { lower in
            T.hotPercentRange << lower
        }
        self.upper = upper.flatMap { upper in
            T.hotPercentRange << upper
        }
    }
    
    /// 翻转左侧百分比
    /// 0.6 -> 0.4 | 0.3 -> 0.7
    var reverseLower: T? {
        lower.flatMap { left in
            1.0 - left
        }
    }
    
    /// 分割百分比(带符号): 左侧百分比为负数
    var signedLower: T? {
        lower.map(\.negation)
    }
}
