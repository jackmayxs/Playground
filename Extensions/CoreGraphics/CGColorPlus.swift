//
//  CGColorPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/11.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension CGColor {
	
	
	/// 使用十六进制数字创建CGColor
	/// - Parameters:
	///   - hex: 十六进制数字颜色
	///   - alpha: 透明度
	/// - Returns: A new CGColor
	static func hex(_ hex: UInt32, alpha: CGFloat = 1) -> CGColor {
        UIColor.hex(hex, alpha: alpha).cgColor
    }
}
