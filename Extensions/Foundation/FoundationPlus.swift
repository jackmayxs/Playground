//
//  FoundationPlus.swift
//  ExtensionDemo
//
//  Created by Ori on 2020/8/2.
//  Copyright © 2020 Choi. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var safeValue: String { self ?? "" }
	
	/// 判断Optional<String>类型是否为空
	var isEmptyString: Bool {
		switch self {
		case .some(let unwrapped): return unwrapped.isEmpty
		case .none: return true
		}
	}
}
