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

extension ClosedRange where Bound == CGFloat {
    static let percentRange = CGFloat.percentRange
}

extension ClosedRange where Bound == Double {
    static let percentRange = Double.percentRange
}

extension ClosedRange where Bound == Int {
    
    /// 返回保留前几个数的Range. 例如: 1...5 保留前三个数 -> 1...3 | 如果截取失败则返回原值
    func keep(first: Int) -> Self {
        let limit = index(before: endIndex)
        guard let upperBound = index(startIndex, offsetBy: first - 1, limitedBy: limit) else { return self }
        return lowerBound...self[upperBound]
    }
    
    /// 返回保留后几个数的Range. 例如: 1...5 保留后三个数 -> 3...5 | 如果截取失败则返回原值
    func keep(last: Int) -> Self {
        guard let lowerBound = index(endIndex, offsetBy: -last, limitedBy: startIndex) else { return self }
        return self[lowerBound]...upperBound
    }
    
    /// 将范围映射成索引
    var indexRange: ClosedRange<Int> {
        lowerBound.index...upperBound.index
    }
    
    var numberRange: ClosedRange<Int> {
        lowerBound.number...upperBound.number
    }
    
    /// 转换成CGFloat范围
    var cgFloatRange: ClosedRange<CGFloat> {
        lowerBound.cgFloat...upperBound.cgFloat
    }
}

extension ClosedRange where Bound: BinaryInteger {
    
    /// 转换成Double范围
    var doubleRange: ClosedRange<Double> {
        lowerBound.double...upperBound.double
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

extension Range where Bound == Int {
    
    /// 循环Index | 如: 利用下标循环访问数组的元素
    subscript (cycledIndex nextIndex: Bound) -> Bound? {
        /// 序列为空的情况返回nil | 如: 0..<0
        if lowerBound == upperBound { return nil }
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

extension ClosedRange {
    
    /// 根据传入值计算进度
    /// - Parameter value: 传入值
    /// - Returns: 进度百分比<0~1.0>
    public func progress(for value: Bound) -> Double where Bound: BinaryInteger {
        doubleRange.progress(for: value.double)
    }
    
    /// 根据传入值计算进度
    /// - Parameter value: 传入值
    /// - Returns: 进度百分比<0~1.0>
    public func progress(for value: Bound) -> Bound where Bound: BinaryFloatingPoint {
        do {
            /// 检查范围
            let constrainedValue = try constrainedResult(value).get()
            /// 总进度
            let rangeWidth = upperBound - lowerBound
            /// 确保除数不为0
            guard rangeWidth != 0 else { return 1.0 }
            /// 计算进度
            return (constrainedValue - lowerBound) / rangeWidth
        } catch RangeValueError.tooHigh {
            return 1.0
        } catch {
            return 0.0
        }
    }
    
    /// 判断左面的范围是否包含右面
    /// - Returns: 包含则返回true, 否则返回false
    static func ~=(lhs: Self, rhs: Self) -> Bool {
        /// clamped -> Always return a smaller range
        rhs.clamped(to: lhs) == rhs
    }
    
    /// 返回限制后的值
    /// - Parameters:
    ///   - lhs: ClosedRange
    ///   - rhs: 值
    /// - Returns: 限制在范围内的值
    static func <<(lhs: Self, rhs: Bound) -> Bound {
        lhs.constrainedValue(rhs)
    }
    
    /// 将传入的值限制在范围内部 | 过大或过小则取相应的极值
    /// - Parameter value: 需要限制的传入值
    /// - Returns: 限制过后的值
    func constrainedValue(_ value: Bound) -> Bound {
        if value < lowerBound {
            lowerBound
        } else if value > upperBound {
            upperBound
        } else {
            value
        }
        /// 实现方法2 | 可读性较差
        /// Swift.min(Swift.max(value, lowerBound), upperBound)
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

extension ClosedRange where Bound: BinaryFloatingPoint {
    
    /// 计算范围和百分比相乘之后得出范围内的值
    /// - Parameters:
    ///   - lhs: 闭合范围
    ///   - rhs: 百分比: 0...1.0
    /// - Returns: 范围内的值
    public static func * (lhs: ClosedRange<Bound>, percentage: Bound) -> Bound {
        let clampedPercentage = Bound.hotPercentRange << percentage
        let distance = lhs.upperBound - lhs.lowerBound
        return lhs.lowerBound + distance * clampedPercentage
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
