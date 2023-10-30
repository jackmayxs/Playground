//
//  CGFloatPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static let percentRange: ClosedRange<CGFloat> = 0...1.0
}

extension CGFloat {
	
    /// 返回 0...1.0 之间的随机数
	static var randomPercent: CGFloat {
		CGFloat.random(in: percentRange)
	}
	
    var int: Int {
        Int(self)
    }
    
    var float: Float {
        Float(self)
    }
    
	var double: Double {
		Double(self)
	}
    
    var half: CGFloat {
        self / 2.0
    }
    
    var isNegative: Bool {
        self < 0
    }
    
    var isPositive: Bool {
        self > 0
    }
}
