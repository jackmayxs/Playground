//
//  RangePlus.swift
//
//  Created by Choi on 2022/12/6.
//

import Foundation

extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
    
    init(_ slice: Slice<Self>) {
        let lower = slice.base[slice.startIndex]
        let upper = slice.base[slice.index(before: slice.endIndex)]
        self.init(uncheckedBounds: (lower: lower, upper: upper))
    }
}

extension ClosedRange where Bound == Int {
    
    /// 求出指定值在本范围内的进度
    /// - Parameter value: 要计算进度的值
    /// - Returns: 进度
    func percentageAt(_ value: Bound) -> Double {
        guard contains(value) else { return 0.0 }
        return Double(value - lowerBound) / count.double
    }
    
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
    
    /// 将传入的值限制在范围内部 | 过大或过小则取相应的极值
    /// - Parameter value: 需要限制的传入值
    /// - Returns: 限制过后的值
    func constrainedValue(_ value: Bound) -> Bound {
        if value < lowerBound {
            return lowerBound
        } else if value > upperBound {
            return upperBound
        } else {
            return value
        }
    }
    
    /// 将传入值限制在范围内
    /// - Parameter value: 需要限制的值
    /// - Returns: Result包含有效值或错误
    func constrainedResult(_ value: Bound) -> Result<Bound, RangeValueError> {
        if value < lowerBound {
            return .failure(.tooLow)
        } else if value > upperBound {
            return .failure(.tooHigh)
        } else {
            return .success(value)
        }
    }
}

extension ClosedRange: Comparable where Bound: Comparable {
    public static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
        lhs.upperBound < rhs.lowerBound
    }
}

enum RangeValueError: Error {
    case tooLow
    case tooHigh
}
