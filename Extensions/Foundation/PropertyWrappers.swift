//
//  PropertyWrappers.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/9.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

@propertyWrapper
final class Temporary<T> {
	
	typealias ValueBuilder = () -> T
	
	private var value: T?
	private lazy var timer = GCDTimer.scheduledTimer(
		delay: .now() + survivalTime,
		queue: .global(qos: .background)
	) { _ in
		self.value = .none
	}
	private let survivalTime: TimeInterval
	private let builder: ValueBuilder
	init(wrappedValue: @escaping ValueBuilder, expireIn survivalTime: TimeInterval) {
		self.builder = wrappedValue
		self.survivalTime = survivalTime
	}
	var wrappedValue: T {
		defer {
			// 每次调用都推迟执行
			timer.fire(.now() + survivalTime)
		}
		guard let unwrapped = value else {
			value = builder()
			return value.unsafelyUnwrapped
		}
		return unwrapped
	}
}
