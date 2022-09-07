//
//  PropertyWrappers.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/7/9.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

@propertyWrapper
struct Cached<T> {
    
    var wrappedValue: T? {
        get {
            UserDefaults.standard.value(forKey: key) as? T
        }
        set {
            guard let validValue = newValue else { return }
            UserDefaults.standard.setValue(validValue, forKey: key)
        }
    }
    let key: String
    init(wrappedValue: T? = nil, key: String) {
        self.key = key
    }
}

@propertyWrapper
final class EditDetectable<E> where E: Equatable {
	
	var projectedValue: EditDetectable<E> {
		self
	}
	private var value: E?
	var wrappedValue: E? {
		get { value }
		set {
			value = newValue
			
			/// 根据命中条件决定是否继续执行 '命中' 方法
			if requirements.contains(.valid), newValue == .none { return }
			if let string = newValue as? String,
			   requirements.contains(.validString),
			   string.isEmptyString { return }
			hit(newValue)
		}
	}
	var needsUpdate: Bool {
		if hitCache.isEmpty { // 未命中
			return false
		} else { // 至少命中1次
			guard hitCache.count > 1 else {
				// 只命中了1次
				if requirements.contains(.ignoreInitialValue) {
					return false
				}
				return true
			}
			// 命中了2次以上
			// 校验当前值是否满足指定条件
			var isValid: Bool {
				guard requirements.contains(.valid) else { return true }
				return wrappedValue != .none
			}
			var isNotEmptyString: Bool {
				guard requirements.contains(.validString) else { return true }
				guard let string = wrappedValue as? String else { return false }
				return !string.isEmptyString
			}
			return isValid && isNotEmptyString && hitCache.first != hitCache.last
		}
	}
	
	private var lock = NSLock()
	private var hitCache: [E?] = []
	private func hit(_ value: E?) {
		lock.lock()
		if hitCache.count == 2 {
			hitCache.removeLast()
		}
		hitCache.append(value)
		lock.unlock()
	}
	
	private let requirements: ValueRequirement
	init(wrappedValue: E?, requirements: ValueRequirement = [.valid]) {
		self.requirements = requirements
		self.wrappedValue = wrappedValue
	}
}

struct ValueRequirement: OptionSet {
	let rawValue: Int
	static let valid              = ValueRequirement(rawValue: 1 << 0)
	static let validString        = ValueRequirement(rawValue: 1 << 1)
	static let ignoreInitialValue = ValueRequirement(rawValue: 1 << 2)
}


@propertyWrapper // 忽略Optional.none
class ValidValueOnly<T> where T: Equatable {
	private var value: T?
	init(wrappedValue: T?) {
		self.value = wrappedValue
	}
	var wrappedValue: T? {
		get { value }
		set {
			guard let validValue = newValue else {
				return // 直接忽略空值
			}
			value = validValue
		}
	}
}

@propertyWrapper // 忽略空字符串
final class IgnoreEmptyString: ValidValueOnly<String> {
	override var wrappedValue: String? {
		get { super.wrappedValue }
		set { super.wrappedValue = newValue.validStringOrNone }
	}
}

@propertyWrapper
/// 临时的变量: 超时后自动销毁 | 再次访问时重新创建
final class Temporary<T> {
	
	typealias ValueBuilder = () -> T
	
	private var value: T?
    private let survivalTime: DispatchTimeInterval
    private let builder: ValueBuilder
    private lazy var timer = GCDTimer.scheduledTimer(delay: .now() + survivalTime, queue: .global(qos: .utility)) {
        [weak self] _ in self?.value = .none
    }
    init(wrappedValue: @escaping ValueBuilder, expireIn survivalTime: DispatchTimeInterval) {
        self.builder = wrappedValue
        self.survivalTime = survivalTime
    }
    var wrappedValue: T {
        defer { /// 每次调用都推迟执行
            timer.fire(.now() + survivalTime)
        }
        guard let unwrapped = value else {
            value = builder()
            return value.unsafelyUnwrapped
        }
        return unwrapped
    }
    
    deinit {
        timer.invalidate()
    }
}

@propertyWrapper
/// 转瞬即逝的变量
final class Transient<T> {
    private var value: T?
    private let interval: DispatchTimeInterval
    private lazy var timer = GCDTimer.scheduledTimer(delay: .now() + interval, queue: .global(qos: .utility)) {
        [weak self] _ in self?.value = .none
    }
    
    init(wrappedValue: T? = nil, venishAfter interval: DispatchTimeInterval = 1.0) {
        self.value = wrappedValue
        self.interval = interval
    }
    
    private func countDown() {
        timer.fire(.now() + interval)
    }
    
    var wrappedValue: T? {
        get {
            defer {
                if value != nil {
                    /// 每次调用都推迟执行
                    countDown()
                }
            }
            return value
        }
        set {
            defer {
                if value != nil {
                    /// 每次调用都推迟执行
                    countDown()
                }
            }
            value = newValue
        }
    }
    
    deinit {
        timer.invalidate()
    }
}
