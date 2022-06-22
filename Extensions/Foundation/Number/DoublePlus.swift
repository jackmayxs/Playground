//
//  NumberPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/22.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension Numeric {
	var spellout: String? {
		NumberFormatter.spellout.string(for: self)
	}
}

// MARK: - __________ Common __________
extension Double {
	
	var nsNumber: NSNumber {
		NSNumber(value: self)
	}
	
	var int: Int {
		Int(self)
	}
	
	var cgFloat: CGFloat {
		CGFloat(self)
	}
}

// MARK: - __________ Date __________
extension Double {
	
	/// 计算指定日期元素内的秒数
	/// - Parameter component: 日期元素 | 可处理的枚举: .day, .hour, .minute, .second, .nanosecond
	/// - Returns: 时间间隔
	static func timeInterval(in component: Calendar.Component) -> TimeInterval {
		let now = Date()
		let treatableComponents: [Calendar.Component] = [.day, .hour, .minute, .second, .nanosecond]
		guard treatableComponents.contains(component) else {
			assertionFailure("\(component)'s time interval may vary in current date: \(now)")
			return 0.0
		}
		return Calendar.gregorian.dateInterval(of: component, for: now)?.duration ?? 0.0
	}
}

// MARK: - __________ Format __________
extension Double {
	
	// 默认设置
	fileprivate var decimalFormatter: NumberFormatter {
		NumberFormatter.shared
			.configure { make in
				make.numberStyle = .decimal
				make.maximumFractionDigits = 2
			}
	}
	
	/// 四舍五入的Formatter
	fileprivate var roundDecimalFormatter: NumberFormatter {
		decimalFormatter.configure { make in
			make.roundingMode = .halfUp
		}
	}
	
	// 带正负号的Formatter
	fileprivate var signedDecimalFormatter: NumberFormatter {
		decimalFormatter.configure { make in
			make.positivePrefix = "+"
			make.negativePrefix = "-"
		}
	}
	
	/// 带符号 | 四舍五入
	var signedR2: String {
		signedDecimalFormatter.configure { make in
			make.roundingMode = .halfUp
		}.transform { fmt -> String in
			fmt.string(from: nsNumber) ?? ""
		}
	}
	
	/// 带符号 | 原样输出
	var signedF: String {
		signedDecimalFormatter.transform { fmt -> String in
			fmt.string(from: nsNumber) ?? ""
		}
	}
	
	/// 带符号 | 保留两位小数
	var signedF2: String {
		signedDecimalFormatter.configure { make in
			make.minimumFractionDigits = 2
		}.transform { fmt -> String in
			fmt.string(from: nsNumber) ?? ""
		}
	}
	
	/// 四舍五入 | 原样输出
	var r2: String {
		roundDecimalFormatter.transform { fmt -> String in
			fmt.string(from: nsNumber) ?? ""
		}
	}
	
	/// 原样输出
	var f: String {
		decimalFormatter.configure { make in
			make.minimumFractionDigits = 0
		}.transform { fmt -> String in
			fmt.string(from: nsNumber) ?? ""
		}
	}
	
	/// 保留两位小数的字符串
	var f2: String {
		decimalFormatter.configure { make in
			make.minimumFractionDigits = 2
		}.transform { fmt -> String in
			fmt.string(from: nsNumber) ?? ""
		}
	}
}
