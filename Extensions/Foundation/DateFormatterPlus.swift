//
//  DateFormatterPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/11/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

extension DateFormatter {
	
	@Temporary<DateFormatter>(expireIn: 300)
	fileprivate static var sharedDateFormatter = DateFormatter.init
	
	static var shared: DateFormatter {
		sharedDateFormatter.reset()
	}
	
	@discardableResult
	private func reset() -> DateFormatter {
		formattingContext = .unknown
		dateFormat = ""
		dateStyle = .full
		timeStyle = .none
		locale = .chineseSimplified
		generatesCalendarDates = false
		timeZone = .current
		calendar = .current
		isLenient = false
		doesRelativeDateFormatting = false
		defaultDate = nil
		formatterBehavior = .behavior10_4
		return self
	}
}
