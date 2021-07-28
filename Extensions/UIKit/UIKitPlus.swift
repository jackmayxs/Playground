//
//  File.swift
//  ExtensionDemo
//
//  Created by Major on 2021/7/28.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIRectCorner: CaseIterable {
	public static var allCases: [UIRectCorner] {
		[.topLeft, .topRight, .bottomLeft, .bottomRight]
	}
}

extension CACornerMask {
	public static var allCorners: CACornerMask {
		[
			.layerMinXMinYCorner,
			.layerMaxXMinYCorner,
			.layerMinXMaxYCorner,
			.layerMaxXMaxYCorner
		]
	}
}

extension UIRectCorner {
	
	/// UIRectCorner 转换成 CACornerMask
	var caCornerMask: CACornerMask {
		Self.allCases
			.filter(contains)
			.map(\.rawValue)
			.map(CACornerMask.init)
			.reduce(CACornerMask()) { result, item in
				result.union(item)
			}
	}
}
