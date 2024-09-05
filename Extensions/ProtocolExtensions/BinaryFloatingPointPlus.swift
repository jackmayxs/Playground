//
//  BinaryFloatingPointPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/12/5.
//

import Foundation

extension BinaryFloatingPoint {
    
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
    
    var nsNumber: NSNumber {
        NSNumber(value: double)
    }
    
    var decimal: Decimal {
        Decimal(double)
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
    func progress(in range: ClosedRange<Self>) -> Self {
        range.progress(for: self)
    }
}

extension BinaryFloatingPoint {
    
    // 默认设置
    fileprivate var decimalFormatter: NumberFormatter {
        NumberFormatter.shared.configure { make in
            /// 数字格式: 小数
            make.numberStyle = .decimal
            /// 最大小数位: 2
            make.maximumFractionDigits = 2
        }
    }
    
    /// 四舍五入的Formatter
    fileprivate var roundDecimalFormatter: NumberFormatter {
        decimalFormatter.configure { make in
            make.roundingMode = .halfUp
        }
    }
    
    // 带正负号的Formatter
    fileprivate var signedDecimalFormatter: NumberFormatter {
        decimalFormatter.configure { make in
            make.positivePrefix = "+"
            make.negativePrefix = "-"
            make.zeroSymbol = "0" /// 格式化成带有正负号的数字时,0不带符号
        }
    }
    
    var percentage: String {
        percentString(fractions: 0) ?? ""
    }
    
    /// 带符号 | 四舍五入
    var signedR2: String {
        signedDecimalFormatter.configure { make in
            make.roundingMode = .halfUp
        }.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
    
    /// 带符号 | 原样输出
    var signedF: String {
        signedDecimalFormatter.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
    
    /// 带符号 | 保留两位小数
    var signedF2: String {
        signedDecimalFormatter.configure { make in
            make.minimumFractionDigits = 2
        }.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
    
    /// 四舍五入 | 原样输出
    var r2: String {
        roundDecimalFormatter.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
    
    /// 原样输出
    var f: String {
        decimalFormatter.configure { make in
            make.minimumFractionDigits = 0
            make.maximumFractionDigits = .max
        }.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
    
    /// 保留两位小数的字符串
    var f2: String {
        f(2)
    }
    
    var f4: String {
        f(4)
    }
    
    func percentString(fractions: Int = 0) -> String? {
        NumberFormatter.shared.configure { formatter in
            formatter.numberStyle = .percent
            /// 因为在formatter.shared方法里把这个值重置了, 所以这里要在此设置, 否则百分化会失败
            formatter.positiveSuffix = "%"
            formatter.minimumFractionDigits = fractions
            formatter.maximumFractionDigits = fractions
        }.transform { formatter in
            formatter.string(from: nsNumber)
        }
    }
    
    func signedF(_ fractionDigits: Int) -> String {
        signedDecimalFormatter.configure { make in
            make.minimumFractionDigits = fractionDigits
            make.maximumFractionDigits = fractionDigits
        }.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
    
    func f(_ fractionDigits: Int) -> String {
        decimalFormatter.configure { make in
            make.minimumFractionDigits = fractionDigits
            make.maximumFractionDigits = fractionDigits
        }.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
}
