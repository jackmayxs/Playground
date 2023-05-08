//
//  RangePlus.swift
//  zeniko
//
//  Created by Choi on 2022/12/6.
//

import Foundation

extension ClosedRange where Bound == Int {
    
    /// 将范围映射成索引
    var indexRange: ClosedRange<Int> {
        lowerBound.index...upperBound.index
    }
    
    var numberRange: ClosedRange<Int> {
        lowerBound.number...upperBound.number
    }
}

extension ClosedRange where Bound: FixedWidthInteger {
    
    var isSingleRange: Bool {
        upperBound - lowerBound == 0
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

extension ClosedRange: Comparable where Bound: Comparable {
    public static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
        lhs.upperBound < rhs.lowerBound
    }
}
