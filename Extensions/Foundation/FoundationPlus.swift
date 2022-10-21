//
//  FoundationPlus.swift
//  ExtensionDemo
//
//  Created by Ori on 2020/8/2.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

// MARK: - __________ Top Level Functions __________

/// 方法转换
/// - Parameters:
///   - value: 被引用的对象
///   - closure: 具体的执行代码
/// - Returns: A closure
func combine<A, B>(_ value: A, with closure: @escaping (A) -> B) -> () -> B {
	{ closure(value) }
}

/// 方法转换
/// - Parameter output: 默认返回值
/// - Returns: A Closure which will return the output by default.
func sink<In, Out>(_ output: Out) -> (In) -> Out {
	{ _ in output }
}

func sink<In>(_ simpleCallBack: @escaping SimpleCallback) -> (In) -> Void {
    { _ in simpleCallBack() }
}

// MARK: - __________ Locale __________
extension Locale {
	static let chineseSimplified = Locale(identifier: "zh_CN")
	static let chineseTraditional = Locale(identifier: "zh-Hant_CN")
}
