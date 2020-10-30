//
//  FoundationPlus.swift
//  ExtensionDemo
//
//  Created by Ori on 2020/8/2.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

// MARK: - __________ Optional __________
extension Optional where Wrapped == String {
	var safeValue: String { self ?? "" }
	
	/// 判断Optional<String>类型是否为空
	var isEmptyString: Bool {
		switch self {
			case .some(let unwrapped): return unwrapped.isEmpty
			case .none: return true
		}
	}
	
	/// 返回不为空字符串的Optional<String>
	var validString: Self {
		isEmptyString ? .none : unsafelyUnwrapped
	}
}

// MARK: - __________ Date __________
extension Date {
	
	/// 计算两个日期之间相差的DateComponents
	/// - 注意：两个日期的先后顺序，如果开始日期晚于结束日期，返回的DateComponents里的元素将为负数
	/// - Parameters:
	///   - lhs: 开始时间
	///   - rhs: 结束时间
	/// - Returns: DateComponents
	static func >> (lhs: Date, rhs: Date) -> DateComponents {
		Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lhs, to: rhs)
	}
	
	/// 返回当前时间
	static var now: Date { Date() }
	
	/// 返回当前时间只包含小时的时间
	static var hourOfClock: Date {
		let cal = Calendar.current
		var components = cal.dateComponents(in: .current, from: .now)
		components.minute = 0
		components.second = 0
		components.nanosecond = 0
		return cal.date(from: components).unsafelyUnwrapped
	}
}

// MARK: - __________ String __________
infix operator <-- : MultiplicationPrecedence
infix operator --> : MultiplicationPrecedence
extension String {
	
	/// 使用右侧的字符串
	/// - Parameters:
	///   - lhs: 左操作对象
	///   - rhs: 右操作对象
	/// - Note: 以下两个方法对于字典类型在合并其他字典时的回调闭包里使用语法糖时较为有用
	/// - Example:　aDict.merging(anotherOne) { $0 <-- $1 } // 使用当前值(如果直接返回$0会触发编译器错误)
	static func --> (lhs: String, rhs: String) -> String { rhs }
	
	/// 使用左侧的字符串
	/// - Parameters:
	///   - lhs: 左操作对象
	///   - rhs: 右操作对象
	static func <-- (lhs: String, rhs: String) -> String { lhs }
}
