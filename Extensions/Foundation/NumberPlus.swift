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
	
	var cgFloat: CGFloat {
		CGFloat(self)
	}
}

extension CGFloat {
	
	static var random: CGFloat {
		CGFloat.random(in: 0.0...1.0)
	}
}
