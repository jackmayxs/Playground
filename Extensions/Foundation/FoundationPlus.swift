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
func combine<A, B>(
	_ value: A,
	with closure: @escaping (A) -> B
) -> () -> B {
	{ closure(value) }
}

/// 方法转换
/// - Parameter output: 默认返回值
/// - Returns: A Closure which will return the output by default.
func sink<In, Out>(_ output: Out) -> (In) -> Out {
	{ _ in output }
}

// MARK: - __________ Operators __________
infix operator <-- : MultiplicationPrecedence
infix operator --> : MultiplicationPrecedence

// MARK: - __________ Dictionary __________
extension Dictionary where Value: OptionalType {
	var unwrapped: Dictionary<Key, Value.Wrapped> {
		reduce(into: [Key:Value.Wrapped]()) { partialResult, tuple in
			guard let value = tuple.value.optionalValue else { return }
			partialResult[tuple.key] = value
		}
	}
}

// MARK: - __________ Array __________
infix operator +> : MultiplicationPrecedence

extension Array {
	public init(generating elementGenerator: (Int) -> Element, count: Int) {
		self = (0..<count).map(elementGenerator)
	}
	public init(generating elementGenerator: () -> Element, count: Int) {
		self = (0..<count).map { _ in
			elementGenerator()
		}
	}
}

extension Array where Element : Hashable {
	
	/// 添加唯一的元素
	/// - Parameter newElement: 遵循Hashable的元素
	mutating func appendUnique(_ newElement:Element) {
		let isNotUnique = contains { element in
			element.hashValue == newElement.hashValue
		}
		guard !isNotUnique else { return }
		append(newElement)
	}
	
	/// 合并唯一的元素 | 可用于reduce
	/// - Parameters:
	///   - lhs: 数组
	///   - rhs: 要添加的元素
	/// - Returns: 结果数组
	static func +> (lhs: Self, rhs: Element) -> Self {
		var result = lhs
		result.appendUnique(rhs)
		return result
	}
	
	/// 合并数组
	/// - Parameters:
	///   - lhs: 原数组
	///   - rhs: 新数组
	/// - Returns: 合并唯一元素的数组
	static func +> (lhs: Self, rhs: Self) -> Self {
		rhs.reduce(lhs, +>)
	}
}

// MARK: - __________ ArraySlice __________
extension ArraySlice {
	
	/// 转换为Array
	var array: Array<Element> {
		Array(self)
	}
}

// MARK: - __________ Optional __________

extension Optional: OptionalType {
	var optionalValue: Wrapped? { self }
}

extension Optional {
	
	var itself: Self {
		self
	}
	
	var isNotValid: Bool {
		!isValid
	}
	
	var isValid: Bool {
		do {
			_ = try unwrap()
			return true
		} catch {
			return false
		}
	}
	
	/// 转换为Any类型
	var any: Any {
		self as Any
	}
	
	/// 解包Optional
	/// - Parameter error: 抛出的错误
	/// - Returns: Wrapped Value
	func unwrap(onError error: Error? = nil) throws -> Wrapped {
		guard let unwrapped = self else {
			if let error = error {
				throw error
			} else {
				throw OptionalError.badValue
			}
		}
		return unwrapped
	}
	
	/// 解包Optional
	/// - Parameter defaultValue: 自动闭包
	/// - Returns: Wrapped Value
	func ifNil(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
		guard let wrapped = try? unwrap() else {
			return defaultValue()
		}
		return wrapped
	}
	func ifNil<T>(_ defaultValue: T, else transform: (Wrapped) -> T) -> T {
		guard let wrapped = try? unwrap() else {
			return defaultValue
		}
		return transform(wrapped)
	}
	func ifNil<T>(_ defaultValue: T, else transform: @autoclosure () -> T) -> T {
		guard let _ = try? unwrap() else {
			return defaultValue
		}
		return transform()
	}
	
	/// Optional Error
	enum OptionalError: LocalizedError {
		case badValue
		
		var errorDescription: String? {
			"Bad \(Wrapped.self)."
		}
	}
}

extension Bool {
	
	var isFalse: Bool {
		self == false
	}
}

extension DateFormatter {
	
	private static let formatterCache: NSCache<NSString, DateFormatter> = {
		let cache = NSCache<NSString, DateFormatter>()
		cache.countLimit = 5
		func clearCache(_ note: Notification) {
			cache.removeAllObjects()
		}
		NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil, using: clearCache(_:))
		NotificationCenter.default.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: nil, using: clearCache(_:))
		return cache
	}()
	static func newInstance(withFormat format: String, local: Locale = .current) -> DateFormatter {
		let key = (format + local.identifier) as NSString
		let dateFormatter = formatterCache.object(forKey: key)
		guard let cachedFormatter = dateFormatter else {
			let newFormatter = DateFormatter()
			newFormatter.dateFormat = format
			newFormatter.locale = local
			formatterCache.setObject(newFormatter, forKey: key)
			return newFormatter
		}
		return cachedFormatter
	}
}
