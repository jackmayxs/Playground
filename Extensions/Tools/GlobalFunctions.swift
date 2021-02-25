//
//  GlobalFunctions.swift
//  ExtensionDemo
//
//  Created by Major on 2021/2/25.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

func dePrint<T>(_ message: T, file: String = #fileID, function: String = #function, line: Int = #line) {
	#if DEBUG
		var fileName = (file as NSString).lastPathComponent
		if fileName.hasSuffix(".swift") {
			let startIndex = fileName.index(fileName.startIndex, offsetBy: fileName.count - 6)
			let rang = startIndex..<fileName.endIndex
			fileName.removeSubrange(rang)
		}
		let time = Date().beijingTimeString
		let queue = Thread.isMainThread ? "" : "NOT-MAIN-THREAD"
		print("\(time) \(fileName).\(function)[\(line)]\(queue):\(message)\n")
	#endif
}
