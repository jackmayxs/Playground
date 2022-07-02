//
//  RunloopBootcamp.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/6/28.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation

final class PermenantThread: NSObject {
	private var thread: Thread!
	private var stopped = false
	
	override init() {
		super.init()
		let thread = Thread {
			[weak self] in
			let runloop = RunLoop.current
			runloop.add(Port(), forMode: .default)
			while !(self?.stopped ?? true) {
				runloop.run(mode: .default, before: .distantFuture)
			}
		}
		thread.name = "com.permenant.thread"
		thread.start()
		self.thread = thread
	}
	
	deinit {
		stop()
	}
}

extension PermenantThread {
	
	// MARK: - __________ 执行过程 __________
	@objc private func _execute(_ wrapper: SimpleCallbackWrapper) {
		wrapper.callback()
	}
	
	func execute(_ task: @escaping SimpleCallback) {
		guard let thread = thread else { return }
		let callbackWrapper = SimpleCallbackWrapper(task)
		perform(#selector(_execute), on: thread, with: callbackWrapper, waitUntilDone: false)
	}
	
	// MARK: - __________ 回收过程 __________
	@objc private func _stop() {
		stopped = true
		CFRunLoopStop(CFRunLoopGetCurrent())
		thread = nil
	}
	
	private func stop() {
		guard let thread = thread else { return }
		perform(#selector(_stop), on: thread, with: nil, waitUntilDone: true)
	}
}
