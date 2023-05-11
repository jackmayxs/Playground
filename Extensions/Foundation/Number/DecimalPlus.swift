//
//  DecimalPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/5/11.
//

import Foundation

extension Decimal {
    
    /// 获取小数位数, 即小数精确位数
    /// 0.0001 -> 4; 0.03500 -> 3
    var significantFractionalDecimalDigits: Int {
        max(-exponent, 0)
    }
    
    var intValue: Int {
        nsDecimalNumber.intValue
    }
    
    var doubleValue: Double {
        nsDecimalNumber.doubleValue
    }
    
    var nsDecimalNumber: NSDecimalNumber {
        NSDecimalNumber(decimal: self)
    }
}
