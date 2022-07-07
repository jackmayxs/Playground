//
//  IntPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

// MARK: - __________ Common __________
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
}

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
