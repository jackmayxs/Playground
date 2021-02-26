//
//  CGFloatPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/26.
//  Copyright © 2021 Choi. All rights reserved.
//

import CoreGraphics

extension CGFloat {
	
	static var random: CGFloat {
		CGFloat.random(in: 0.0...1.0)
	}
	
	var double: Double {
		Double(self)
	}
}
