//
//  NumberPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/22.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

// MARK: - __________ Int __________
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
	// MARK: - __________ Date __________
	var days: Int { 24 * hours }
	var hours: Int { self * 60.minutes }
	var minutes: Int { self * 60.seconds }
	var seconds: Int { self }
}

extension Double {
	
	fileprivate static var sharedNumberFormatter = NumberFormatter()
	
	// 默认设置
	fileprivate var decimalFormatter: NumberFormatter {
		Self.sharedNumberFormatter.configure { make in
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
			fmt.string(from: number) ?? ""
		}
	}
	
	/// 带符号 | 原样输出
	var signedF: String {
		signedDecimalFormatter.transform { fmt -> String in
			fmt.string(from: number) ?? ""
		}
	}
	
	/// 带符号 | 保留两位小数
	var signedF2: String {
		signedDecimalFormatter.configure { make in
			make.minimumFractionDigits = 2
		}.transform { fmt -> String in
			fmt.string(from: number) ?? ""
		}
	}
	
	/// 四舍五入 | 原样输出
	var r2: String {
		roundDecimalFormatter.transform { fmt -> String in
			fmt.string(from: number) ?? ""
		}
	}
	
	/// 原样输出
	var f: String {
		decimalFormatter.configure { make in
			make.minimumFractionDigits = 0
		}.transform { fmt -> String in
			fmt.string(from: number) ?? ""
		}
	}
	
	/// 保留两位小数的字符串
	var f2: String {
		decimalFormatter.configure { make in
			make.minimumFractionDigits = 2
		}.transform { fmt -> String in
			fmt.string(from: number) ?? ""
		}
	}
	
	/// 转换为NSNumber
	var number: NSNumber {
		NSNumber(value: self)
	}
	
	var cgFloat: CGFloat {
		CGFloat(self)
	}
}

extension CGFloat {
	
	static var random: CGFloat {
		CGFloat.random(in: 0.0...1.0)
	}
}
