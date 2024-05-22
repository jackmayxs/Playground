//
//  ClosedRangePlus.swift
//  KnowLED
//
//  Created by Choi on 2023/12/28.
//

import Foundation

extension ClosedRange where Bound == CGFloat {
    static let percentRange = CGFloat.percentRange
}

extension ClosedRange where Bound == Double {
    static let percentRange = Double.percentRange
}

extension ClosedRange where Bound == Int {
    
    /// 上下边界分别偏移一定的距离
    /// - Parameter distance: 偏移距离
    /// - Returns: 新的范围对象
    public func offseted(by distance: Bound) -> ClosedRange<Bound> {
        (lowerBound + distance)...(upperBound + distance)
    }
    
    public mutating func offset(by distance: Bound) {
        self = (lowerBound + distance)...(upperBound + distance)
    }
    
    /// 计算一个Range在另一个Range中的索引范围
    /// - Parameter another: 要计算的Range
    /// - Returns: 索引范围
    func indexRange(of another: ClosedRange<Bound>) -> Range<Int>? {
        guard self ~= another else { return nil }
        let startIndex = lowerBound.distance(to: another.lowerBound)
        let endIndex = lowerBound.distance(to: another.upperBound) + 1
        guard startIndex < endIndex else { return nil }
        return startIndex..<endIndex
    }
    
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
            /// Range宽度
            let rangeWidth = width
            /// 除数不能为零
            guard rangeWidth != 0 else {
                /// 上下边界相等 | 大于等于上限则返回1.0
                return value >= upperBound ? 1.0 : 0.0
            }
            /// 检查范围
            let constrainedValue = try constrainedResult(value).get()
            /// 计算进度
            return (constrainedValue - lowerBound) / rangeWidth
        } catch RangeBoundError.tooLow {
            return 0.0
        } catch RangeBoundError.tooHigh {
            return 1.0
        } catch {
            fatalError("Never happens")
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
        do {
            return try constrainedResult(value).get()
        } catch RangeBoundError.tooLow {
            return lowerBound
        } catch RangeBoundError.tooHigh {
            return upperBound
        } catch {
            fatalError("Never happens")
        }
        /// 另一种实现方法 | 可读性较差
        /// Swift.min(Swift.max(value, lowerBound), upperBound)
    }
    
    /// 将传入值限制在范围内
    /// - Parameter value: 需要限制的值
    /// - Returns: Result包含有效值或错误
    func constrainedResult(_ value: Bound) -> Result<Bound, RangeBoundError> {
        if value < lowerBound {
            return .failure(.tooLow)
        } else if value > upperBound {
            return .failure(.tooHigh)
        } else {
            return .success(value)
        }
    }
}

extension ClosedRange where Bound: BinaryInteger {
    
    public static func * (lhs: Self, percentage: Double) -> Bound {
        Bound(lhs.doubleRange * percentage)
    }
    
    /// 转换成CGFloat范围
    var cgFloatRange: ClosedRange<CGFloat> {
        lowerBound.cgFloat...upperBound.cgFloat
    }
    
    /// 转换成Double范围
    var doubleRange: ClosedRange<Double> {
        lowerBound.double...upperBound.double
    }
}

extension ClosedRange where Bound: BinaryFloatingPoint {
    
    /// 计算范围和百分比相乘之后得出范围内的值
    /// - Parameters:
    ///   - lhs: 闭合范围
    ///   - rhs: 百分比: 0...1.0
    /// - Returns: 范围内的值
    public static func * (lhs: Self, percentage: Bound) -> Bound {
        lhs.lowerBound + lhs.width * (Bound.hotPercentRange << percentage)
    }
}

extension ClosedRange where Bound: Equatable {
    
    /// 例如像1...1这样的闭合范围
    var isNarrow: Bool {
        upperBound == lowerBound
    }
}

extension ClosedRange where Bound: AdditiveArithmetic {
    
    /// 返回ClosedRange的宽度(上限-下限)
    var width: Bound {
        upperBound - lowerBound
    }
}

extension ClosedRange: Comparable where Bound: Comparable {
    public static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
        lhs.upperBound < rhs.lowerBound
    }
}

// MARK: - 其他
@frozen enum RangeBoundError: Error {
    case tooLow
    case tooHigh
}
