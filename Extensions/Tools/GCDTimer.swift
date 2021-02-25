//
//  GCDTimer.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/2/25.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

final class GCDTimer {
	
	private lazy var lock = DispatchSemaphore(value: 1)
	private var timerSource: DispatchSourceTimer?
	private var validTimer: DispatchSourceTimer {
		guard let timer = timerSource else {
			timerSource = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
			return timerSource.unsafelyUnwrapped
		}
		return timer
	}
	private var isValid: Bool {
		timerSource != nil
	}
	
	let timeInterval: DispatchTimeInterval
	let queue: DispatchQueue
	let repeats: Bool
	let block: (GCDTimer) -> Void
	init(timeInterval: DispatchTimeInterval,
		 queue: DispatchQueue = .main,
		 repeats: Bool = true,
		 block: @escaping (GCDTimer) -> Void)
	{
		self.timeInterval = timeInterval
		self.queue = queue
		self.repeats = repeats
		self.block = block
		
		validTimer.setEventHandler(handler: tickTock)
	}
	
	/// 创建Timer
	/// - Parameters:
	///   - interval: 时间间隔
	///   - delay: 延迟时间
	///   - repeats: 是否重复
	///   - block: 回调方法
	@discardableResult
	static func scheduledTimer(
		timeInterval: DispatchTimeInterval,
		delay: DispatchTime = .now(),
		queue: DispatchQueue = .main,
		repeats: Bool = true,
		block: @escaping (GCDTimer) -> Void) -> GCDTimer {
		let timer = self.init(timeInterval: timeInterval, queue: queue, repeats: repeats, block: block)
		timer.fire(delay)
		return timer
	}
	
	private func tickTock() {
		_ = lock.wait(timeout: .distantFuture)
		if repeats {
			lock.signal()
			block(self)
		} else {
			lock.signal()
			invalidate()
		}
	}
	
	func invalidate() {
		_ = lock.wait(timeout: .distantFuture)
		if isValid {
			validTimer.cancel()
			timerSource = .none
		}
		lock.signal()
	}
	
	func suspend() {
		validTimer.suspend()
	}
	
	func resume() {
		validTimer.resume()
	}
	
	func fire(_ delay: DispatchTime = .now()) {
		validTimer.schedule(
			deadline: delay,
			repeating: repeats ? timeInterval : .never
		)
		resume()
	}
	
	deinit {
		invalidate()
	}
}
