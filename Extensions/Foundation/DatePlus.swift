//
//  DatePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/7.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

extension Date {
	
	var beijingTimeString: String {
		DateFormatter.new { make in
			make.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			// 使用identifier
			make.timeZone = TimeZone(identifier: "Asia/Shanghai")
			// 使用缩写
			make.timeZone = TimeZone(abbreviation: "GMT+8")
			// 💋使用东八区偏移秒数
			make.timeZone = TimeZone(secondsFromGMT: 8.hours)
		}
		.string(from: self)
	}
	
	fileprivate static var CurrentCalendar: Calendar = {
		var cal = Calendar.current
		cal.locale = Locale.current
		return cal
	}()
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
			CurrentCalendar.dateComponents(components, from: lhs, to: rhs)
		}
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
