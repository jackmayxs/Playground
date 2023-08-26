//
//  OptionalPlus.swift
//
//  Created by Choi on 2022/8/18.
//

import Foundation

extension Optional {
    
    var isNotValid: Bool {
        !isValid
    }
    
    var isValid: Bool {
        guard let _ = self else { return false }
        return true
    }
    
    /// 转换为Any类型
    var asAny: Any {
        self as Any
    }
    
    /// 过滤指定条件
    /// - Parameter predicate: 过滤条件
    /// - Returns: 满足指定条件的结果
    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let unwrapped = self, predicate(unwrapped) else { return nil }
        return unwrapped
    }
    
    /// 如果不为空则以解包后的值作为入参执行闭包
    /// - Parameter execute: 回调闭包
    @discardableResult
    func unwrap(execute: (Wrapped) throws -> Void) rethrows -> Wrapped? {
        guard let self else { return nil }
        try execute(self)
        return self
    }
    
    /// 解包Optional
    /// - Parameter error: 抛出的错误
    /// - Returns: Wrapped Value
    func unwrap(onError error: Error? = nil) throws -> Wrapped {
        guard let self else {
            if let error = error {
                throw error
            } else {
                throw OptionalError.badValue
            }
        }
        return self
    }
    
    /// 解包
    /// - Parameters:
    ///   - transform: 转换解包后的值
    ///   - defaultValue: 默认值
    /// - Returns: 转换后的值
    func unwrap<T>(_ transform: (Wrapped) -> T, or defaultValue: @autoclosure () -> T) -> T {
        guard let self else {
            return defaultValue()
        }
        return transform(self)
    }
    
    /// 解包
    /// - Parameters:
    ///   - defaultValue: 默认值
    ///   - transform: 转换闭包
    /// - Returns: 转换后的值
    /// 注: 和上面的unwrap方法作用一样, 但是在将尾随闭包作为转换回调时可以使代码看起来更清晰. 如:
    /// let num: Int? = 0
    /// num.or("") { num in
    ///     num.string
    /// }
    func or<T>(_ defaultValue: @autoclosure () -> T, else transform: (Wrapped) -> T) -> T {
        guard let self else {
            return defaultValue()
        }
        return transform(self)
    }
    
    /// 解包Optional
    /// - Parameter defaultValue: 自动闭包
    /// - Returns: Wrapped Value
    func or(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        guard let self else {
            return defaultValue()
        }
        return self
    }
    
    static func <-- (lhs: Wrapped?, rhs: Wrapped?) -> Wrapped? {
        lhs ?? rhs
    }
    
    static func --> (lhs: Wrapped?, rhs: Wrapped?) -> Wrapped? {
        rhs ?? lhs
    }
    
    /// Optional Error
    enum OptionalError: LocalizedError {
        case badValue
        
        var errorDescription: String? {
            "Bad \(Wrapped.self)."
        }
    }
}

extension Optional where Wrapped: Sequence & ExpressibleByArrayLiteral {
    var orEmpty: Wrapped {
        or(.empty)
    }
}
