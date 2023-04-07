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
    
    /// 去掉argb的alpha通道
    var rgb: Int {
        Int((uInt32 << 8) >> 8)
    }
    
    var int: Int {
        Int(truncatingIfNeeded: self)
    }
    
    var int64: Int64 {
        Int64(truncatingIfNeeded: self)
    }
    
    var int32: Int32 {
        Int32(truncatingIfNeeded: self)
    }
    
    var int16: Int16 {
        Int16(truncatingIfNeeded: self)
    }
    
    var int8: Int8 {
        Int8(truncatingIfNeeded: self)
    }
    
    var uInt64: UInt64 {
        UInt64(truncatingIfNeeded: self)
    }
    
    var uInt32: UInt32 {
        UInt32(truncatingIfNeeded: self)
    }
    
    public var uInt16: UInt16 {
        UInt16(truncatingIfNeeded: self)
    }
    
    public var uInt8: UInt8 {
        UInt8(truncatingIfNeeded: self)
    }
    
    
    /// 二进制
    var data: Data {
        dataInBytes()
    }
    
    /// 转换为二进制
    /// - Parameters:
    ///   - byteCount: 占用字节数, 如不指定则使用自身默认占用的字节数
    ///   - byteOrder: 字节序, 默认为小字节序
    /// - Returns: 转换后的二进制对象(字节翻转过的数组: 从左到右为低位到高位排列)
    /// 加注: 默认为小字节序: 二进制从左往右为数字的二进制从低位(右侧)到高位(左侧)按字节依次填充
    func dataInBytes(_ byteCount: Int? = nil, byteOrder: Data.ByteOrder = .littleEndian) -> Data {
        var copy = byteOrder == .bigEndian ? int.bigEndian : int.littleEndian
        let count = byteCount ?? MemoryLayout.size(ofValue: self)
        return Data(bytes: &copy, count: count)
    }
    
    /// 占用的二进制位数
    var bitSize: Int {
        MemoryLayout.size(ofValue: self)
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
    
    /// 索引转换成序号
    var number: Int {
        self + 1
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
