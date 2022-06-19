//
//  Operators.swift
//  ExtensionDemo
//
//  Created by Major on 2022/6/19.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation

// MARK: - __________ 优先级组 __________

// MARK: - __________ 操作符 __________
infix operator <-- : MultiplicationPrecedence
infix operator --> : MultiplicationPrecedence
infix operator +> : MultiplicationPrecedence
infix operator ??= : AssignmentPrecedence

// MARK: - __________ 具体实现 __________
/// 唯空赋值运算符: To assign only if the assigned-to variable is nil
func ??= <T>(lhs: inout T?, rhs: T?) {
	guard lhs == nil else { return }
	lhs = rhs
}
