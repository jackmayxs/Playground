//
//  CGRectPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/18.
//  Copyright © 2021 Choi. All rights reserved.
//

import CoreGraphics

extension CGRect {
	
	/// 中心点
	var center: CGPoint {
		CGPoint(x: midX, y: midY)
	}
	
	/// 对Rect进行缩放
	/// - Parameter ratio: 缩放比率
	mutating func zoom(_ ratio: CGFloat) {
		origin.x *= ratio
		origin.y *= ratio
		size.width *= ratio
		size.height *= ratio
	}
	
	/// 对Rect进行缩放
	/// - Parameter ratio: 比率
	/// - Returns: 缩放后的Rect
	func zoomed(_ ratio: CGFloat) -> CGRect {
		var newRect = self
		newRect.zoom(ratio)
		return newRect
	}
	func insetBySize(_ size: CGSize) -> CGRect {
		insetBy(dx: size.width, dy: size.height)
	}
	func offsetBySize(_ size: CGSize) -> CGRect {
		offsetBy(dx: size.width, dy: size.height)
	}
}
