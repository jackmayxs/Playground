//
//  ProtocolExtensions.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/8/28.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

// MARK: - __________ Equatable __________
extension Equatable {
	var optional: Self? { self }
}

// MARK: - __________ Collection __________
extension Collection {
    
    func removeDuplicates<Value>(for keyPath: KeyPath<Element, Value>) -> [Element] where Value: Equatable {
        removeDuplicates { element1, element2 in
            element1[keyPath: keyPath] == element2[keyPath: keyPath]
        }
    }
    
    func removeDuplicates(includeElement: (Element, Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { element in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
    
    func filledOr(_ defaultValue: Self) -> Self {
        isNotEmpty ? self : defaultValue
    }
    
    /// 如果为空则返回nil
    var filledOrNil: Self? {
        isNotEmpty ? self : nil
    }
    
	var isNotEmpty: Bool {
		!isEmpty
	}
}
// MARK: - __________ Sequence __________
extension Sequence where Iterator.Element: OptionalType {
	var unwrapped: [Iterator.Element.Wrapped] {
		compactMap(\.optionalValue)
	}
}
extension Sequence where Self: ExpressibleByArrayLiteral {
	
	/// 空序列
	static var empty: Self {
		[]
	}
}

extension Sequence {
	func `as`<T>(_ type: T.Type) -> [T] {
		compactMap { element in
			element as? T
		}
	}
}

extension Sequence where Element: Hashable {
    var set: Set<Element> {
        Set(self)
    }
}

// MARK: - __________ 扩展BinaryInteger协议 __________

extension BinaryInteger {
    
    var string: String {
        String(self)
    }
    
    /// 去掉argb的alpha通道
    var rgb: Int {
        Int((uInt32 << 8) >> 8)
    }
    
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    
    var double: Double {
        Double(self)
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
    
    var uInt: UInt {
        UInt(truncatingIfNeeded: self)
    }
    
    var uInt64: UInt64 {
        UInt64(truncatingIfNeeded: self)
    }
    
    var uInt32: UInt32 {
        UInt32(truncatingIfNeeded: self)
    }
    
    var uInt16: UInt16 {
        UInt16(truncatingIfNeeded: self)
    }
    
    var uInt8: UInt8 {
        UInt8(truncatingIfNeeded: self)
    }
    
    /// 占用的字节数
    var byteCount: Int {
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

extension FixedWidthInteger {
    
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
    func dataInBytes(_ preferredByteCount: Int? = nil, byteOrder: Data.ByteOrder = .littleEndian) -> Data {
        var copy = byteOrder == .bigEndian ? bigEndian : littleEndian
        let byteCount = preferredByteCount ?? bitWidth / 8
        return Data(bytes: &copy, count: byteCount)
    }
}

extension BinaryInteger {
    
    static postfix func ++(input: inout Self) -> Self {
        defer {
            input += 1
        }
        return input
    }
    
    static prefix func ++(input: inout Self) -> Self {
        input += 1
        return input
    }
    
    static postfix func --(input: inout Self) -> Self {
        defer {
            input -= 1
        }
        return input
    }
    
    static prefix func --(input: inout Self) -> Self {
        input -= 1
        return input
    }
}
