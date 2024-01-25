//
//  RangePlus.swift
//
//  Created by Choi on 2022/12/6.
//

import Foundation

extension Range {
    
    /// 判断左面的范围是否包含右面
    /// - Returns: 包含则返回true, 否则返回false
    static func ~=(lhs: Self, rhs: Self) -> Bool {
        /// clamped -> Always return a smaller range
        rhs.clamped(to: lhs) == rhs
    }
}

extension Range where Bound: BinaryInteger {
    
    /// 用于数组indices属性,返回最后一个index || 数组非空时有值
    var lastIndex: Bound? {
        isEmpty ? nil : upperBound - 1
    }
}

extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
    
    /// 循环Index | 如: 利用下标循环访问数组的元素
    subscript (cycledIndex nextIndex: Bound) -> Bound? {
        /// 序列为空的情况返回nil | 如: 10..<10
        if isEmpty { return nil }
        /// 大于等于上限 | 返回最小Index
        if nextIndex >= upperBound {
            return lowerBound
        }
        /// 小于下限 | 返回最大Index
        else if nextIndex < lowerBound {
            return index(before: endIndex)
        } else {
            return nextIndex
        }
    }
}
