//
//  CGFloatPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import CoreGraphics

extension CGFloat {
	
    /// 返回 0...1.0 之间的随机数
	static var randomPercent: CGFloat {
		CGFloat.random(in: percentRange)
	}
    
    func constrained(in range: ClosedRange<CGFloat>) -> CGFloat {
        range << self
    }
}
