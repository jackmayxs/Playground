//
//  UIEdgeInsetsPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/11/4.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
extension NSDirectionalEdgeInsets {
	
	var uiEdgeInsets: UIEdgeInsets {
		switch UIApplication.shared.userInterfaceLayoutDirection {
			case .leftToRight:
				return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
			case .rightToLeft:
				return UIEdgeInsets(top: top, left: trailing, bottom: bottom, right: leading)
			@unknown default:
				return .zero
		}
	}
}

extension UIEdgeInsets {
	var reversed: UIEdgeInsets {
		UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
	}
	
	@available (iOS 11.0, *)
	var directionalEdgeInsets: NSDirectionalEdgeInsets {
		switch UIApplication.shared.userInterfaceLayoutDirection {
			case .leftToRight:
				return NSDirectionalEdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
			case .rightToLeft:
				return NSDirectionalEdgeInsets(top: top, leading: right, bottom: bottom, trailing: left)
			@unknown default:
				fatalError("UNKNOWN DIRECTION")
		}
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
