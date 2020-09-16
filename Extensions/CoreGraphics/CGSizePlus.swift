//
//  CoreGraphicPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/9/16.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

protocol ExtendableBySize {
	
	/// 垂直方向扩展
	var vertical: CGFloat { get }
	
	/// 水平方向扩展
	var horizontal: CGFloat { get }
}

extension UIEdgeInsets: ExtendableBySize {
	var vertical: CGFloat { left + right }
	var horizontal: CGFloat { top + bottom }
}

extension CGSize: ExtendableBySize {
	var vertical: CGFloat { width }
	var horizontal: CGFloat { height }
}

extension CGSize {
	
	/// 给CGSize加另外的宽高
	/// - Parameters:
	///   - lhs: CGSize
	///   - rhs: 遵循了ExtendableBySize协议的对象
	/// - Returns: A new CGSize
    static func + (lhs: CGSize, rhs: ExtendableBySize) -> CGSize {
        var size = lhs
        size.width += rhs.horizontal
		size.height += rhs.vertical
        return size
    }
}
