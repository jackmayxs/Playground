//
//  StringPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/7.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension String {
	
	/// 返回SF Symbol图片
	var systemImage: UIImage? {
		UIImage(systemName: self)
	}
	
	/// 生成图片
	var image: UIImage? {
		UIImage(named: self)
	}
}

// MARK: - __________ String: LocalizedError __________
extension String: LocalizedError {
	public var errorDescription: String? {
		self
	}
}

// MARK: - __________ String? __________
extension Optional where Wrapped == String {
	
	var orEmpty: String { self ?? "" }
	
	/// 判断Optional<String>类型是否为空(.none或Wrapped为空字符串)
	var isEmptyString: Bool {
		switch self {
			case .some(let wrapped): return wrapped.isEmptyString
			case .none: return true
		}
	}
	
	/// 判断Optional是否有效(Wrapped非空字符串)
	var isValidString: Bool {
		!isEmptyString
	}
	
	/// 返回有效的字符串或空字符串
	var validString: Wrapped {
		isEmptyString ? "" : unsafelyUnwrapped
	}
	
	/// 返回有效的字符串或.none
	var validStringOrNone: Self {
		isEmptyString ? .none : unsafelyUnwrapped
	}
}

// MARK: - __________ StringProtocol __________
extension StringProtocol {
	
	/// 返回一个字符串占用多少字节数
	var utf8ByteCount: Int {
		lengthOfBytes(using: .utf8)
	}
	
	var cgFloat: CGFloat {
		CGFloat(double)
	}
	var int: Int {
		Int(double)
	}
	var double: Double {
		Double(self).ifNil(0.0)
	}
}

// MARK: - __________ Range<String.Index> __________
extension RangeExpression where Bound == String.Index  {
	func nsRange<S: StringProtocol>(in string: S) -> NSRange {
		NSRange(self, in: string)
	}
}

// MARK: - __________ String __________
extension String {
	
	/// 使用右侧的字符串
	/// - Parameters:
	///   - lhs: 左操作对象
	///   - rhs: 右操作对象
	/// - Note: 以下两个方法对于字典类型在合并其他字典时的回调闭包里使用语法糖时较为有用
	/// - Example:　aDict.merging(anotherOne) { $0 << $1 } // 使用当前值(如果直接返回$0会触发编译器错误)
	static func >> (lhs: String, rhs: String) -> String { rhs }
	
	/// 使用左侧的字符串
	/// - Parameters:
	///   - lhs: 左操作对象
	///   - rhs: 右操作对象
	static func << (lhs: String, rhs: String) -> String { lhs }
}
extension String {
	
	func indices(of occurrence: String) -> [Int] {
		var indices: [Int] = []
		var position = startIndex
		while let range = range(of: occurrence, range: position..<endIndex) {
			let i = distance(from: startIndex, to: range.lowerBound)
			indices.append(i)
			let offset = occurrence.distance(from: occurrence.startIndex, to: occurrence.endIndex) - 1
			guard let after = index(range.lowerBound, offsetBy: offset, limitedBy: endIndex) else {
				break
			}
			position = index(after: after)
		}
		return indices
	}
	func ranges(of searchString: String) -> [Range<String.Index>] {
		let _indices = indices(of: searchString)
		let count = searchString.count
		return _indices.map {
			index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0 + count)
		}
	}
	func nsRanges(of searchString: String) -> [NSRange] {
		ranges(of: searchString).map { $0.nsRange(in: self) }
	}
}
// MARK: - __________ Verification __________
extension String {
	
	static var random: String {
		UUID().uuidString
	}
	
	func isValid(for characterSet: CharacterSet) -> Bool {
		false
	}
	
	var trimmed: String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	var isEmptyString: Bool {
		trimmed.isEmpty
	}
	
	var isValidString: Bool {
		!isEmptyString
	}
	
	/// 判断字符串是否满足字符集中的字符(严格匹配)
	/// - Parameters:
	///   - characterSet: 匹配的字符集
	///   - options: 匹配选项
	/// - Returns: 检查结果
	func match(_ characterSet: CharacterSet, options: CompareOptions = []) -> Bool {
		rangeOfCharacter(from: characterSet.inverted, options: options) == .none
	}
	
	/// 字符串中是否包含指定字符集中的字符
	/// - Parameters:
	///   - characterSet: 匹配的字符集
	///   - options: 匹配选项
	/// - Returns: 检查结果
	func containsCharacter(in characterSet: CharacterSet, options: CompareOptions = []) -> Bool {
		rangeOfCharacter(from: characterSet, options: options) != .none
	}
	
	/// 移除不需要的字符
	/// - Parameter notAllowed: 不需要的字符集 | 可以用正常字符集反向获取到
	mutating func removeCharacters(in notAllowed: CharacterSet) {
		unicodeScalars.removeAll { scalar in
			notAllowed.contains(scalar)
		}
	}
	
	/// 移除不需要的字符 | 返回新字符串
	/// - Parameter notAllowed: 不需要的字符集 | 可以用正常字符集反向获取到
	/// - Returns: 处理过的字符串
	func removingCharacters(in notAllowed: CharacterSet) -> String {
		var copy = self
		copy.removeCharacters(in: notAllowed)
		return copy
	}
	
	var validStringOrNone: String? {
		isEmptyString ? .none : self
	}
	
	var optional: String? {
		self
	}
}

extension Substring {
	
	var string: String {
		String(self)
	}
}

extension String {
	
	subscript (_ range: ClosedRange<Int>) -> String {
		get {
			guard range.upperBound < count else {
				return ""
			}
			let start = index(startIndex, offsetBy: range.lowerBound)
			let end = index(startIndex, offsetBy: range.upperBound)
			return self[start ... end].string
		}
		set {
			guard range.upperBound < count else {
				return
			}
			let start = index(startIndex, offsetBy: range.lowerBound)
			let end = index(startIndex, offsetBy: range.upperBound)
			replaceSubrange(start ... end, with: newValue)
		}
	}
	
	subscript (_ range: PartialRangeFrom<Int>, head head: String = "") -> String {
		get {
			guard range.lowerBound < count else {
				return ""
			}
			let start = index(startIndex, offsetBy: range.lowerBound)
			return head + self[start...].string
		}
		set {
			guard range.lowerBound < count else {
				return
			}
			let start = index(startIndex, offsetBy: range.lowerBound)
			replaceSubrange(start..., with: newValue)
		}
	}
	
	subscript (_ range: PartialRangeThrough<Int>, tail tail: String = "") -> String {
		get {
			guard range.upperBound < count else {
				return self
			}
			let index = index(startIndex, offsetBy: range.upperBound)
			let cropped = self[...index].string
			return cropped + (count > cropped.count ? tail : "")
		}
		set {
			guard range.upperBound < count else {
				return
			}
			let index = index(startIndex, offsetBy: range.upperBound)
			replaceSubrange(...index, with: newValue)
		}
	}
}
