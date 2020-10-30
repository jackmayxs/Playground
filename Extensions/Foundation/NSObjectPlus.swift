//
//  NSObjectPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

extension NSObject {
	
	/// 转换成指针
	public var rawPointer: UnsafeMutableRawPointer {
		Unmanaged.passUnretained(self).toOpaque()
	}
}
