//
//  RunloopBootcamp.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/6/28.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation

final class PermenantThread: NSObject {
	private var innerThread: XThread!
	private var stopped = false
	
	override init() {
		super.init()
		innerThread = XThread {
			[weak self] in
			let xRunloop = RunLoop.current
			xRunloop.add(Port(), forMode: .default)
			while !(self?.stopped ?? true) {
				xRunloop.run(mode: .default, before: .distantFuture)
			}
		}
		innerThread.start()
	}
	
	deinit {
		stop()
	}
}

extension PermenantThread {
	
	// MARK: - __________ 执行过程 __________
	@objc private func _executeTask(_ wrapper: SimpleCallbackWrapper) {
		wrapper.callback()
	}
	
	func executeTask(_ task: @escaping SimpleCallback) {
		guard innerThread.isValid else { return }
		let callbackWrapper = SimpleCallbackWrapper(task)
		perform(#selector(_executeTask), on: innerThread, with: callbackWrapper, waitUntilDone: false)
	}
	
	// MARK: - __________ 回收过程 __________
	@objc private func _stop() {
		stopped = true
		CFRunLoopStop(CFRunLoopGetCurrent())
		innerThread = nil
	}
	
	private func stop() {
		guard innerThread.isValid else { return }
		perform(#selector(_stop), on: innerThread, with: nil, waitUntilDone: true)
	}
	
	// MARK: - __________ 内嵌类型 __________
	final class XThread: Thread {
		override init() {
			super.init()
			name = "XThread"
		}
		deinit {
			dprint("XThread 销毁")
		}
	}
}
