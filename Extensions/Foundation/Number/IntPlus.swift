//
//  IntPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

// MARK: - Optional<Int>
extension Optional where Wrapped == Int {
    
    var orZero: Int { self ?? 0 }
}

// MARK: - UInt16
extension UInt16 {
    var int: Int {
        Int(self)
    }
}

// MARK: - Common

extension BinaryInteger {
    
    
    /// 以自身类型的长度转换成二进制
    var data: Data {
        dataInBytes(MemoryLayout.size(ofValue: self))
    }
    
    /// 整型 -> 二进制
    /// - Parameter byteCount: 放入几个字节中
    /// - Returns: 二进制对象
    func dataInBytes(_ byteCount: Int? = nil) -> Data {
        var myInt = self
        let count = byteCount ?? MemoryLayout.size(ofValue: myInt)
        return Data(bytes: &myInt, count: count)
    }
    
    var hexString: String {
        stringOfRadix(16, uppercase: true)
    }
    
    /// 数字转换为指定进制字符串
    /// - Parameters:
    ///   - radix: 进制: 取值范围: 2...36
    ///   - uppercase: 字母是否大写
    /// - Returns: 转换成功后的字符串
    func stringOfRadix(_ radix: Int, uppercase: Bool = true) -> String {
        guard (2...36) ~= radix else {
            assertionFailure("NO SUCH RADIX 🤯")
            return ""
        }
        return String(self, radix: radix, uppercase: uppercase)
    }
}

extension Int {
	
	// 获取一个整形数字个十百千...位上的数字. 例如:
	// 746381295[0] == 5 个位数字
	// 746381295[1] == 9 十位数字...
	subscript(digitIndex: Int) -> Int {
		var decimalBase = 1
		for _ in 0 ..< digitIndex {
			decimalBase *= 10
		}
		return (self / decimalBase) % 10
	}
    
    /// 例: 1 -> 01; 10 -> 10
    var twoDigits: String? {
        digits(2)
    }
    
    func digits(_ minimumIntegerDigits: Int = 1) -> String? {
        NumberFormatter.shared.configure { formatter in
            formatter.minimumIntegerDigits = minimumIntegerDigits
        }.transform { formatter in
            formatter.string(from: self.nsNumber)
        }
    }
    
    var isZero: Bool {
        self == 0
    }
    
    var isNegative: Bool {
        self < 0
    }
    
    var isPositive: Bool {
        self > 0
    }
    
    /// 转换成索引值
    var index: Int {
        Swift.max(0, self - 1)
    }
	
    var bool: Bool {
        self > 0 ? true : false
    }
    
	var cgFloat: CGFloat {
		CGFloat(self)
	}
	
	var double: Double {
		Double(self)
	}
	
	var int32: Int32 {
		Int32(self)
	}
	
	var int64: Int64 {
		Int64(self)
	}
    
    var string: String {
        String(self)
    }
    
    var nsNumber: NSNumber {
        NSNumber(value: self)
    }
}

// MARK: - Int + Calendar
extension Int {
	
	static func * (lhs: Int, component: Calendar.Component) -> DateComponents {
		var components = DateComponents(calendar: .gregorian)
		components.setValue(lhs, for: component)
		return components
	}
	
	/// 计算指定日期元素的秒数
	/// - Parameter component: 日期元素 | 可处理的枚举: .day, .hour, .minute, .second, .nanosecond
	/// - Returns: 秒数
	static func seconds(in component: Calendar.Component) -> Int {
		let timeInterval = timeInterval(in: component)
		return Int(timeInterval)
	}
	
	/// 计算指定日期元素的纳秒数
	/// - Parameter component: 日期元素 | 可处理的枚举: .day, .hour, .minute, .second, .nanosecond
	/// - Returns: 纳秒数
	static func nanoseconds(in component: Calendar.Component) -> Int {
		let timeInterval = timeInterval(in: component) * 1e9
		let nanoseconds = timeInterval * 1e9
		return Int(nanoseconds)
	}
	
	/// 计算指定日期元素的时间间隔
	/// - Parameter component: 日期元素 | 可处理的枚举: .day, .hour, .minute, .second, .nanosecond
	/// - Returns: 时间间隔
	fileprivate static func timeInterval(in component: Calendar.Component) -> TimeInterval {
		Double.timeInterval(in: component)
	}
}

// MARK: - Int 操作符
extension Int {
    
    static postfix func ++(input: inout Int) {
        input += 1
    }
}
