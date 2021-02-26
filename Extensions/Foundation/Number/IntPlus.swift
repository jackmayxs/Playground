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
}

// MARK: - __________ Date __________
extension Int {
	var days: Int { 24 * hours }
	var hours: Int { self * 60.minutes }
	var minutes: Int { self * 60.seconds }
	var seconds: Int { self }
}
