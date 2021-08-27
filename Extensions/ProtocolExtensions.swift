//
//  ProtocolExtensions.swift
//  ExtensionDemo
//
//  Created by Major on 2021/8/28.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

// MARK: - __________ Sequence __________
extension Sequence where Self: ExpressibleByArrayLiteral {
	
	/// 空序列
	static var empty: Self {
		[]
	}
}
