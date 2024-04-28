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

extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
    
    /// 用于数组indices属性,返回最后一个index || 数组非空时有值
    var lastIndex: Bound? {
        isEmpty ? nil : index(before: endIndex)
    }
}

extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
    
    /// 循环Index | 如: 利用下标循环访问数组的元素
    /// 如: (0..<3)[cycledIndex: 4] == 0
    /// 如: (8..<11)[cycledIndex: -1] == 10
    subscript (cycledIndex cycledIndex: Bound) -> Bound? {
        /// 序列为空的情况返回nil | 如: 0..<0
        if isEmpty { return nil }
        /// 大于等于上限 | 返回最小Index
        if cycledIndex >= upperBound {
            return lowerBound
        }
        /// 小于下限 | 返回最大Index
        else if cycledIndex < lowerBound {
            return index(before: endIndex)
        } else {
            return cycledIndex
        }
    }
}

extension Range where Bound == Int {
    
    /// 循环Index | 对输入的Index求余使得用余数配合上下限返回有效的索引值
    /// 如: (0..<3)[modIndex: 4] == 1
    /// 如: (8..<11)[modIndex: 3] == 9
    subscript (modIndex modIndex: Bound) -> Bound? {
        /// 序列为空的情况返回nil | 如: 0..<0
        if isEmpty { return nil }
        /// 单个元素情况直接返回lowerBound
        if count == 1 { return lowerBound }
        /// 大于等于上限
        if modIndex >= upperBound {
            let distance = modIndex - upperBound
            return lowerBound + distance % count
        }
        /// 小于下限
        else if modIndex < lowerBound {
            let distance = modIndex - lowerBound
            let mod = distance % count
            return mod == 0 ? lowerBound : index(upperBound, offsetBy: mod)
        } else {
            return modIndex
        }
    }
}
