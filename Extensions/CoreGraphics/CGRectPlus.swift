//
//  CGRectPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/18.
//  Copyright © 2021 Choi. All rights reserved.
//

import CoreGraphics
import UIKit

extension CGRect {
    
    /// 将传入的点限制在自身区域中
    /// - Parameter point: 传入的点
    /// - Returns: 限制后的点
    func constrainedPoint(_ point: CGPoint) -> CGPoint {
        let x = (minX...maxX) << point.x
        let y = (minY...maxY) << point.y
        return CGPoint(x: x, y: y)
    }
    
    /// 从当前Frame生成随机Frame
    /// - Parameter fixSize: 固定随机Rect尺寸
    /// - Returns: 随机尺寸
    func randomPosition(fixSize: CGSize) -> CGRect {
        let x = CGFloat.random(in: minX...maxX - fixSize.width)
        let y = CGFloat.random(in: minY...maxY - fixSize.height)
        let origin = CGPoint(x: x, y: y)
        return CGRect(origin: origin, size: fixSize)
    }
    
    func withNew(size: CGSize) -> CGRect {
        CGRect(origin: origin, size: size)
    }
    
    func withNew(origin: CGPoint) -> CGRect {
        CGRect(origin: origin, size: size)
    }
    
    /// 按照X轴线向上翻转之后的Rect | 用于SPriteKit中的坐标运算
    var flipped: CGRect {
        CGRect(x: origin.x, y: -origin.y, width: width, height: height)
    }
    
    var area: CGFloat {
        size.area
    }
    
    /// 对角线长度
    var diagonal: CGFloat {
        size.diagonal
    }
    
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

extension CGRect {
    
    static func +(lhs: CGRect, rhs: UIEdgeInsets) -> CGRect {
        lhs.inset(by: rhs)
    }
}
