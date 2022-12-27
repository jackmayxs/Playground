//
//  GlobalFunctions.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/25.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

func dprint(_ items: Any..., file: String = #fileID, function: String = #function, line: Int = #line) {
	#if DEBUG
	var fileName = (file as NSString).lastPathComponent
	if fileName.hasSuffix(".swift") {
		let startIndex = fileName.index(fileName.startIndex, offsetBy: fileName.count - 6)
		let rang = startIndex..<fileName.endIndex
		fileName.removeSubrange(rang)
	}
	let time = Date().debugTimeString
	let threadWarning = Thread.isMainThread ? "" : " | Warning: NOT-MAIN-THREAD"
	print("🌿 @Time \(time) \(fileName).\(function) @Line:\(line)\(threadWarning)")
	for (idx, item) in items.enumerated() {
		print("\(idx) ➜ \(item)")
	}
	#endif
}

/// 通过判断当前显示的名字是否是正式发布时的名字来判断
var isTesterDebugging: Bool {
    guard let displayName = Bundle.main.displayName else {
        return true
    }
    return displayName != "Zeniko"
}

var isDebugging: Bool {
    #if DEBUG
    true
    #else
    false
    #endif
}

/// 判断是否是主队列
fileprivate let mainQueueSpecificKey = DispatchSpecificKey<UUID>()
fileprivate let mainQueueID = UUID()
var isMainQueue: Bool {
	Dispatch.once {
		DispatchQueue.main.setSpecific(key: mainQueueSpecificKey, value: mainQueueID)
	}
	return DispatchQueue.getSpecific(key: mainQueueSpecificKey) == mainQueueID
}

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

/// 隐藏键盘
func dismissKeyboard() {
    /// to: 指定参数为nil, 此方法会将Action发送给当前的第一响应者, 从而达到隐藏键盘的效果
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
