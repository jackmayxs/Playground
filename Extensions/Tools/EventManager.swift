//
//  Event.swift
//  ExtensionDemo
//
//  Created by Choi on 2022/6/24.
//  Copyright © 2022 Choi. All rights reserved.
//

import Foundation

struct EventManager {
	
	/// 定义事件数组
	private var events: [() -> Void] = []
	
	/// 添加事件观察者
	/// - Parameters:
	///   - observer: 观察者
	///   - eventTriggered: 触发的回调
	mutating func addObserver<T: AnyObject>(_ observer: T, using eventTriggered: @escaping (T) -> Void) {
		events.append {
			/// 弱引用观察者 | 利用了Optional类型的map方法, 非常巧妙
			[weak observer] in observer.map(eventTriggered)
		}
	}
	
	/// 触发所有事件
	func trigger() {
		events.forEach { event in
			event()
		}
	}
}
