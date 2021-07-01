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

// MARK: - __________ Operators __________
infix operator <-- : MultiplicationPrecedence
infix operator --> : MultiplicationPrecedence

// MARK: - __________ ArraySlice __________
extension ArraySlice {
	
	/// 转换为Array
	var array: Array<Element> {
		Array(self)
	}
}

// MARK: - __________ Optional __________
extension Optional {
	
	/// 转换为Any类型
	var any: Any {
		self as Any
	}
	
	/// 解包Optional
	/// - Throws: 解包失败抛出错误
	/// - Returns: Wrapped Value
	func unwrap() throws -> Wrapped {
		guard let unwrapped = self else {
			throw OptionalError.badValue
		}
		return unwrapped
	}
	
	/// 解包Optional
	/// - Parameter defaultValue: 自动闭包
	/// - Returns: Wrapped Value
	func or(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
		guard let wrapped = try? unwrap() else {
			return defaultValue()
		}
		return wrapped
	}
	func or<T>(_ defaultValue: T, or transform: (Wrapped) -> T) -> T {
		guard let wrapped = try? unwrap() else {
			return defaultValue
		}
		return transform(wrapped)
	}
	
	/// Optional Error
	enum OptionalError: LocalizedError {
		case badValue
		
		var errorDescription: String? {
			"Bad \(Wrapped.self)."
		}
	}
}
// MARK: - __________ CharacterSet __________
extension CharacterSet {
	
	#if DEBUG
	
	/// 获取字符集内所有的字符数组
	/// 注意：由于字符集非常庞大，尤其在使用 <#inverted#> 属性获取翻转后的字符集的时候不要使用此属性
	/// 否则会卡死线程
	var characters: [Character] {
		var result: [Int] = []
		var plane = 0
		for (i, w) in bitmapRepresentation.enumerated() {
			let k = i % 0x2001
			if k == 0x2000 {
				plane = Int(w) << 13
				continue
			}
			let base = (plane + k) << 3
			for j in 0 ..< 8 where w & 1 << j != 0 {
				result.append(base + j)
			}
		}
		return result.compactMap(UnicodeScalar.init).map(Character.init)
	}
	// 常用字符集
	/*
	let sets: [CharacterSet] = [
		.whitespaces, // 19个
		.newlines, // 7个
		.whitespacesAndNewlines, // 26个
		.decimalDigits, // 650个  不止 0...9, 还有一大堆其他文字的数字形式
		.punctuationCharacters, // 798个, 标点符号
		.symbols, // 7564个 包括Emoji表情的各种奇怪符号
		
		.urlUserAllowed,
		.urlPasswordAllowed, // 77个, 上面这俩家伙一样
		.urlHostAllowed, // 80个, 比上面两个多了:[]三个字符: ["!", "$", "&", "\'", "(", ")", "*", "+", ",", "-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "=", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "]", "_", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "~"]
		.urlPathAllowed, // 79个, 比urlHostAllowed多了/@少了;[]
		.urlQueryAllowed, // 81个, 比urlHostAllowed多了/?@少了[]
		.urlFragmentAllowed // 81个, url片段, 同urlQueryAllowed
	]
	*/
	#endif
}

extension Bool {
	
	var isFalse: Bool {
		self == false
	}
}

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
