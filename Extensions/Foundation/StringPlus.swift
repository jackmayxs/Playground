//
//  StringPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/7.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
	
	var safeValue: String { self ?? "" }
	
	/// 判断Optional<String>类型是否为空
	var isEmptyString: Bool {
		switch self {
			case .some(let string): return string.isEmptyString
			case .none: return true
		}
	}
	
	/// 返回不为空字符串的Optional<String>
	var validString: Self {
		isEmptyString ? .none : unsafelyUnwrapped
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
// MARK: - __________ Verification __________
extension String {
	
	var isEmptyString: Bool {
		trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
