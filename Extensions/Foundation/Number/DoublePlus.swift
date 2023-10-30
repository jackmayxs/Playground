//
//  NumberPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/22.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension Numeric {
    var spellout: String? {
        NumberFormatter.spellout.string(for: self)
    }
}

// MARK: - __________ Common __________

extension Double {
    static let percentRange: ClosedRange<Double> = 0...1.0
}

extension Double {
    
    /// 返回毫秒数
    var milliseconds: Int {
        Int(self * 1000)
    }
    
    var isNegative: Bool {
        self < 0
    }
    
    var isPositive: Bool {
        self > 0
    }
    
    var percentage: String {
        percentString(fractions: 0) ?? ""
    }
    
    func percentString(fractions: Int = 0) -> String? {
        NumberFormatter.shared.configure { formatter in
            formatter.numberStyle = .percent
            /// 因为在formatter.shared方法里把这个值重置了, 所以这里要在此设置, 否则百分化会失败
            formatter.positiveSuffix = "%"
            formatter.minimumFractionDigits = fractions
            formatter.maximumFractionDigits = fractions
        }.transform { formatter in
            formatter.string(from: self.nsNumber)
        }
    }
    
    /// 切分成整数和小数两个部分
    var split: (wholeNumber: Double, fractions: Double) {
        /// 创建Double类型的指针
        let pWholeNumber = UnsafeMutablePointer<Double>.allocate(capacity: 1)
        defer {
            pWholeNumber.deallocate()
        }
        /// 执行整数小数分离 | 把整数部分存入指针
        let fractions = Darwin.modf(self, pWholeNumber)
        return (pWholeNumber.pointee, fractions)
    }
    
    var nsNumber: NSNumber {
        NSNumber(value: self)
    }
    
    var int: Int {
        Int(self)
    }
    
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    
    var decimal: Decimal {
        Decimal(self)
    }
    
    var half: Double {
        self / 2.0
    }
}

// MARK: - __________ Date __________
extension Double {
    
    /// 计算指定日期元素内的秒数
    /// - Parameter component: 日期元素 | 可处理的枚举: .day, .hour, .minute, .second, .nanosecond
    /// - Returns: 时间间隔
    static func timeInterval(in component: Calendar.Component) -> TimeInterval {
        let now = Date()
        let treatableComponents: [Calendar.Component] = [.day, .hour, .minute, .second, .nanosecond]
        guard treatableComponents.contains(component) else {
            assertionFailure("\(component)'s time interval may vary in current date: \(now)")
            return 0.0
        }
        return Calendar.gregorian.dateInterval(of: component, for: now)?.duration ?? 0.0
    }
}

// MARK: - __________ Format __________
extension Double {
    
    // 默认设置
    fileprivate var decimalFormatter: NumberFormatter {
        NumberFormatter.shared
            .configure { make in
                make.numberStyle = .decimal
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
        }
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
    
    func f(_ minimumFractionDigits: Int) -> String {
        decimalFormatter.configure { make in
            make.minimumFractionDigits = minimumFractionDigits
        }.transform { fmt -> String in
            fmt.string(from: nsNumber) ?? ""
        }
    }
}
