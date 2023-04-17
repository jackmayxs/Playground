//
//  CoreGraphicPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/9/16.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension Int: SizeExtendable {
    var vertical: CGFloat { cgFloat }
    var horizontal: CGFloat { cgFloat }
}

extension Double: SizeExtendable {
    var vertical: CGFloat { self }
    var horizontal: CGFloat { self }
}

extension CGSize: SizeExtendable {
	var vertical: CGFloat { height }
	var horizontal: CGFloat { width }
}

extension CGSize {
    
	init(_ edges: CGFloat...) {
		guard let width = edges.first else { self.init(width: 0, height: 0); return }
		guard let height = edges.last else { self.init(width: 0, height: 0); return }
		self.init(width: width, height: height)
	}
    
    func heightOffset(_ heightOffset: CGFloat) -> CGSize {
        CGSize(width: width, height: height + heightOffset)
    }
    
    func widthOffset(_ widthOffset: CGFloat) -> CGSize {
        CGSize(width: width + widthOffset, height: height)
    }
    
    func newHeight(_ newHeight: CGFloat) -> CGSize {
        CGSize(width: width, height: newHeight)
    }
    
    func newWidth(_ newWidth: CGFloat) -> CGSize {
        CGSize(width: newWidth, height: height)
    }
    
	/// 给CGSize加另外的宽高
	/// - Parameters:
	///   - lhs: CGSize
	///   - rhs: 遵循了ExtendableBySize协议的对象
	/// - Returns: A new CGSize
	static func + (lhs: CGSize, rhs: SizeExtendable) -> CGSize {
		var size = lhs
		size.width += rhs.horizontal
		size.height += rhs.vertical
		return size
	}
    
    /// 宽高乘以指定的比率
    static func * (lhs: CGSize, rhs: Double) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    /// 宽高分别乘以rhs的宽高
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    
    var ratio: CGFloat {
        height / width
    }
    
    func multiplied(by: CGFloat) -> CGSize {
        var size = self
        size.width *= by
        size.height *= by
        return size
    }
	
	func chopEqually(times: Int, direction: NSLayoutConstraint.Axis) -> CGSize {
		var size = self
		switch direction {
		case .vertical: size.width /= times.cgFloat
		case .horizontal: size.height /= times.cgFloat
		@unknown default: break
		}
		return size
	}
}

extension CGSize: ExpressibleByFloatLiteral {
	public init(floatLiteral value: Double) {
		self.init(width: value, height: value)
	}
}

extension CGSize: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Int) {
		self.init(width: value, height: value)
	}
}

extension CGSize: Comparable {
	public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
		lhs.width * lhs.height < rhs.width * rhs.height
	}
}
