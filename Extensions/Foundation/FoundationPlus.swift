//
//  FoundationPlus.swift
//  ExtensionDemo
//
//  Created by Ori on 2020/8/2.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

// MARK: - __________ Operators __________
infix operator <-- : MultiplicationPrecedence
infix operator --> : MultiplicationPrecedence

// MARK: - __________ ArraySlice __________
extension ArraySlice {
	
	/// 转换为Array
	var array: Array<Element> {
		Array(self)
	}
}

// MARK: - __________ Optional __________
extension Optional {
	
	/// 转换为Any类型
	var any: Any {
		self as Any
	}
	
	/// 解包Optional
	/// - Throws: 解包失败抛出错误
	/// - Returns: Wrapped Value
	func unwrap() throws -> Wrapped {
		guard let unwrapped = self else {
			throw OptionalError.badValue
		}
		return unwrapped
	}
	
	/// 解包Optional
	/// - Parameter defaultValue: 自动闭包
	/// - Returns: Wrapped Value
	func unwrap(ifNone defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
		guard let wrapped = try? unwrap() else {
			return defaultValue()
		}
		return wrapped
	}
	func unwrap<T>(ifNone defaultValue: T, or transform: (Wrapped) -> T) -> T {
		guard let wrapped = try? unwrap() else {
			return defaultValue
		}
		return transform(wrapped)
	}
	
	/// Optional Error
	enum OptionalError: LocalizedError {
		case badValue
		
		var errorDescription: String? {
			"Bad \(Wrapped.self)."
		}
	}
}
