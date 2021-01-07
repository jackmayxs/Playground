//
//  FoundationPlus.swift
//  ExtensionDemo
//
//  Created by Ori on 2020/8/2.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

// MARK: - __________ Optional __________
extension Optional {
	
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
		guard let unwrapped = try? unwrap() else {
			return defaultValue()
		}
		return unwrapped
	}
	
	/// Optional Error
	enum OptionalError: LocalizedError {
		case badValue
		
		var errorDescription: String? {
			"Bad \(Wrapped.self)."
		}
	}
}
