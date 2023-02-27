//
//  RangePlus.swift
//  zeniko
//
//  Created by Choi on 2022/12/6.
//

import Foundation

extension ClosedRange where Bound == Int {
    
    var isSingleRange: Bool {
        upperBound - lowerBound == 0
    }
    
    func fitValueFor(value: Bound) -> Bound {
        if value < lowerBound {
            return lowerBound
        } else if value > upperBound {
            return upperBound
        } else {
            return value
        }
    }
}

extension Range {
    
    /// 判断左面的范围是否包含右面
    /// - Returns: 包含则返回true, 否则返回false
    static func ~=(lhs: Self, rhs: Self) -> Bool {
        /// clamped -> Always return a smaller range
        rhs.clamped(to: lhs) == rhs
    }
}

extension ClosedRange {
    
    /// 判断左面的范围是否包含右面
    /// - Returns: 包含则返回true, 否则返回false
    static func ~=(lhs: Self, rhs: Self) -> Bool {
        /// clamped -> Always return a smaller range
        rhs.clamped(to: lhs) == rhs
    }
}
