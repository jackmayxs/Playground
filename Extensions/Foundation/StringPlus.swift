//
//  StringPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/7.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension Optional where Wrapped == String {
	
	var safeValue: String { self ?? "" }
	
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

// MARK: - __________ Transform __________
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
		Double(self).unwrap(ifNone: 0.0)
	}
}

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
// MARK: - __________ Range __________
extension RangeExpression where Bound == String.Index  {
	func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
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
}

extension Locale {
	
	init(_ language: Language) {
		self.init(identifier: language.identifier)
	}
	
	// MARK: - __________ Languages __________
	enum Language {
		case chinese(Chinese)
		
		var identifier: String {
			switch self {
				case .chinese(let type): return type.rawValue
			}
		}
		// MARK: - __________ Chinese Type __________
		enum Chinese: String {
			case simplified = "zh_Hans"
		}
	}
}

extension Substring {
	
	var string: String {
		String(self)
	}
}
