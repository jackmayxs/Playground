//
//  CGRectPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/18.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension CGRect {
	
	func insetBySize(_ size: CGSize) -> CGRect {
		insetBy(dx: size.width, dy: size.height)
	}
	func offsetBySize(_ size: CGSize) -> CGRect {
		offsetBy(dx: size.width, dy: size.height)
	}
}
