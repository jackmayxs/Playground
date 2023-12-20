//
//  BinaryFloatingPointPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/12/5.
//

import Foundation

extension BinaryFloatingPoint {
    
    /// 实时创建的百分比范围, 尽量避免直接使用. 在常用的类型扩展里储存一份静态常量
    static var hotPercentRange: ClosedRange<Self> { 0...1.0 }
    
    /// 分割百分比: self必须在0...1.0之间, 返回左右两个百分比
    /// 通常用于滑块百分比分割
    /// 往左, 左侧百分比增大, 右侧百分比为空
    /// 往右, 右侧百分比增大, 左侧百分比为空
    /// 居中时(0.5), 两侧百分比都为空
    var percentClip: PercentClip<Self> {
        let percentage = Self.hotPercentRange << self
        if self < 0.5 {
            return PercentClip(lower: 1.0 - percentage / 0.5, upper: nil)
        } else if self == 0.5 {
            return PercentClip(lower: nil, upper: nil)
        } else {
            return PercentClip(lower: nil, upper: (percentage - 0.5) / 0.5)
        }
    }
    
    var int: Int {
        Int(self)
    }
    
    var half: Self {
        self / 2.0
    }
    
    var isNegative: Bool {
        self < 0.0
    }
    
    var isPositive: Bool {
        self > 0.0
    }
    
    var float: Float {
        Float(self)
    }
    
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    
    var double: Double {
        Double(self)
    }
    
    /// 将自己约束在指定范围内
    /// - Parameter range: 指定范围
    /// - Returns: 约束后的值
    func constrained(in range: ClosedRange<Self>) -> Self {
        range << self
    }
    
    /// 计算在指定范围内的百分比
    /// - Parameter range: 指定范围
    /// - Returns: 百分比
    func percentIn(range: ClosedRange<Self>) -> Self {
        let clampedBound = range << self
        let divisor = range.upperBound - range.lowerBound
        guard divisor != 0 else { return 0 }
        return (clampedBound - range.lowerBound) / divisor
    }
}
