//
//  DatePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/7.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

extension Date {
	
	fileprivate static var commonDateFormatter = DateFormatter()
	var regularFormatter: DateFormatter {
		Self.commonDateFormatter.configure { make in
			make.timeZone = .current
			make.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		}
	}
	var beijingFormatter: DateFormatter {
		Self.commonDateFormatter.configure { make in
			make.timeZone = .beijing
			make.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		}
	}
	var debugFormatter: DateFormatter {
		Self.commonDateFormatter.configure { make in
			make.timeZone = .current
			make.dateFormat = "HH:mm:ss.SSS"
		}
	}
	
	var beijingTimeString: String {
		beijingFormatter.string(from: self)
	}
	
	var debugTimeString: String {
		debugFormatter.string(from: self)
	}

	fileprivate static var DefaultCalendarComponents: Set<Calendar.Component> {
		[.year, .month, .day, .hour, .minute, .second, .nanosecond]
	}
	
	/// 计算两个日期之间相差的DateComponents
	/// - 注意：两个日期的先后顺序，如果开始日期晚于结束日期，返回的DateComponents里的元素将为负数
	/// - Parameters:
	///   - lhs: 开始时间
	///   - rhs: 结束时间
	/// - Returns: DateComponents
	static func >> (lhs: Date, rhs: Date) -> DateComponents {
		DefaultCalendarComponents.transform { components -> DateComponents in
			Calendar.current.dateComponents(components, from: lhs, to: rhs)
		}
	}
	
	/// 返回当前时间
	static var now: Date { Date() }
	
	/// 返回当前时间只包含小时的时间
	static var hourOfClock: Date {
		.now.components.minute(0).second(0).nanosecond(0).date.unsafelyUnwrapped
	}
	/// 获取日期所有元素
	var components: DateComponents {
		Calendar.current.dateComponents(in: .current, from: self)
	}
	/// 当天起始时间点
	var dayStart: Date {
		components.hour(0).minute(0).second(0).nanosecond(0).date ?? self
	}
	/// 当天结束时间点
	var dayEnd: Date {
		components.hour(23).minute(59).second(59).nanosecond(0).date ?? self
	}
	
	var desc: String {
		description(with: Locale(.chinese(.simplified)))
	}
}

extension Int {
	var days: Int { 24 * hours }
	var hours: Int { self * 60.minutes }
	var minutes: Int { self * 60.seconds }
	var seconds: Int { self }
}

// Date + DateComponents
func +(_ lhs: Date, _ rhs: DateComponents) -> Date {
	Calendar.current.date(byAdding: rhs, to: lhs)!
}

// DateComponents + Dates
func +(_ lhs: DateComponents, _ rhs: Date) -> Date { rhs + lhs }

// Date - DateComponents
func -(_ lhs: Date, _ rhs: DateComponents) -> Date { lhs + (-rhs) }

// MARK: - __________ TimeZone __________
extension TimeZone {
	
	/// 北京时间
	static var beijing: TimeZone {
		// 北京时间 GMT+8
		TimeZone(secondsFromGMT: 8.hours).unsafelyUnwrapped
		// 使用identifier
		//TimeZone(identifier: "Asia/Shanghai")
		// 使用缩写
		//TimeZone(abbreviation: "GMT+8")
	}
}

// MARK: - __________ DateComponents __________
extension DateComponents {
	
	
	/// 返回有效时间或空
	var validDate: Date? {
		isValidDate ? date.unsafelyUnwrapped : .none
	}
	
	var fromNow: Date {
		Calendar.current.date(byAdding: self, to: .now).unsafelyUnwrapped
	}
	var ago: Date {
		Calendar.current.date(byAdding: -self, to: .now).unsafelyUnwrapped
	}
	
	static func year(_ year: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, year: year)
	}
	static func month(_ month: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, month: month)
	}
	static func day(_ day: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, day: day)
	}
	static func hour(_ hour: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, hour: hour)
	}
	static func minute(_ minute: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, minute: minute)
	}
	static func second(_ second: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, second: second)
	}
	static func nanosecond(_ nanosecond: Int) -> DateComponents {
		DateComponents(calendar: .current, timeZone: .current, nanosecond: nanosecond)
	}
	
	func year(_ year: Int) -> DateComponents {
		var new = self
		new.year = year
		return new
	}
	func month(_ month: Int) -> DateComponents {
		var new = self
		new.month = month
		return new
	}
	func day(_ day: Int) -> DateComponents {
		var new = self
		new.day = day
		return new
	}
	func hour(_ hour: Int) -> DateComponents {
		var new = self
		new.hour = hour
		return new
	}
	func minute(_ minute: Int) -> DateComponents {
		var new = self
		new.minute = minute
		return new
	}
	func second(_ second: Int) -> DateComponents {
		var new = self
		new.second = second
		return new
	}
	func nanosecond(_ nanosecond: Int) -> DateComponents {
		var new = self
		new.nanosecond = nanosecond
		return new
	}
	
	/// 忽略除时间之外的所有历法(防止获取date属性时由于其他项干扰导致获取日期失败的情况)
	var trimmed: DateComponents {
		var temp = self
		temp.weekday = .none
		temp.weekdayOrdinal = .none
		temp.quarter = .none
		temp.weekOfMonth = .none
		temp.weekOfYear = .none
		temp.yearForWeekOfYear = .none
		temp.isLeapMonth = .none
		return temp
	}
	
	/// 削除不需要的日期元素
	/// - Parameter element: 日期元素
	/// - Returns: 新DateComponents
	func erased(to element: Calendar.Component) -> DateComponents {
		switch element {
			case .era:
				return trimmed.year(1).erased(to: .year)
			case .year:
				return trimmed.month(1).erased(to: .month)
			case .month:
				return trimmed.day(1).erased(to: .day)
			case .day:
				return trimmed.hour(0).erased(to: .hour)
			case .hour:
				return trimmed.minute(0).erased(to: .minute)
			case .minute:
				return trimmed.second(0).erased(to: .second)
			case .second:
				return trimmed.nanosecond(0)
			default:
				return self
		}
	}
	
	static func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
		combineComponents(lhs, rhs)
	}

	static func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
		combineComponents(lhs, rhs, multiplier: -1)
	}

	static func combineComponents(_ lhs: DateComponents, _ rhs: DateComponents, multiplier: Int = 1)
	-> DateComponents {
		var result = DateComponents()
		result.nanosecond = (lhs.nanosecond ?? 0) + (rhs.nanosecond ?? 0) * multiplier
		result.second     = (lhs.second     ?? 0) + (rhs.second     ?? 0) * multiplier
		result.minute     = (lhs.minute     ?? 0) + (rhs.minute     ?? 0) * multiplier
		result.hour       = (lhs.hour       ?? 0) + (rhs.hour       ?? 0) * multiplier
		result.day        = (lhs.day        ?? 0) + (rhs.day        ?? 0) * multiplier
		result.weekOfYear = (lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0) * multiplier
		result.month      = (lhs.month      ?? 0) + (rhs.month      ?? 0) * multiplier
		result.year       = (lhs.year       ?? 0) + (rhs.year       ?? 0) * multiplier
		return result
	}
	
	static prefix func -(components: DateComponents) -> DateComponents {
		var result = DateComponents()
		if components.nanosecond != nil { result.nanosecond = -components.nanosecond! }
		if components.second     != nil { result.second     = -components.second! }
		if components.minute     != nil { result.minute     = -components.minute! }
		if components.hour       != nil { result.hour       = -components.hour! }
		if components.day        != nil { result.day        = -components.day! }
		if components.weekOfYear != nil { result.weekOfYear = -components.weekOfYear! }
		if components.month      != nil { result.month      = -components.month! }
		if components.year       != nil { result.year       = -components.year! }
		return result
	}
}

// MARK: - __________ Calendar __________
extension Calendar {
	// 公历
	static let gregorian = Calendar(identifier: .gregorian)
	// 农历
	static let chinese = Calendar(identifier: .chinese)
}
