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

extension Range where Bound: BinaryInteger, Bound.Stride: SignedInteger {
    
    public static func * (lhs: Self, percentage: Bound) -> Bound? {
        lhs[multiply: percentage.double]
    }
    
    /// 计算一个半开范围 × 进度 -> Bound?类型
    subscript (multiply progress: Double, roundingRule rule: FloatingPointRoundingRule? = nil) -> Bound? {
        closedRange.map { closedRange in
            /// 最终结果
            var result = closedRange.doubleRange * progress
            /// 进位之后
            if let rule {
                result.round(rule)
            }
            return Bound(result)
        }
    }
    
    /// 返回一个闭合的范围
    /// 如: 0..<10 -> 0...9 | 如果.isEmpty, 例如: 0..<0, 则返回nil
    /// 用于数组索引范围转换成一个有效的闭合范围
    /// [1,2,3].indexRange -> 0..<3 -> 0...2; 如果数组为空, 则索引范围0..<0 -> nil
    var closedRange: ClosedRange<Bound>? {
        isEmpty ? nil : ClosedRange(self)
    }
    
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
