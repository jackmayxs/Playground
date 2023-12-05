//
//  BinaryFloatingPointPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/12/5.
//

import Foundation

extension BinaryFloatingPoint {
    
    static var percentRange: ClosedRange<Self> { 0...1.0 }
    
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
    
    /// 计算在指定范围内的百分比
    /// - Parameter range: 指定范围
    /// - Returns: 百分比
    func percentIn(range: ClosedRange<Self>) -> Self {
        let clampedValue = range << self
        let divisor = range.upperBound - range.lowerBound
        guard divisor != 0 else { return 0 }
        return (clampedValue - range.lowerBound) / divisor
    }
}
