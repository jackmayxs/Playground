//
//  UIEdgeInsetsPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/11/4.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	var reversed: UIEdgeInsets {
		UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}
}

extension UIEdgeInsets: SizeExtendable {
	var vertical: CGFloat { top + bottom }
	var horizontal: CGFloat { left + right }
}

extension UIEdgeInsets: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	public init(floatLiteral value: Double) {
		self.init(top: value.cgFloat, left: value.cgFloat, bottom: value.cgFloat, right: value.cgFloat)
	}
}

extension UIEdgeInsets: ExpressibleByIntegerLiteral {
	public typealias IntegerLiteralType = Int
	public init(integerLiteral value: Int) {
		self.init(top: value.cgFloat, left: value.cgFloat, bottom: value.cgFloat, right: value.cgFloat)
	}
}
