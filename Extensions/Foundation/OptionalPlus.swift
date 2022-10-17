//
//  OptionalPlus.swift
//  zeniko
//
//  Created by Choi on 2022/8/18.
//

import Foundation

extension Optional: OptionalType {
    var optionalValue: Wrapped? { self }
}

extension Optional: SelfReflectable {
    var itself: Optional<Wrapped> { self }
}

extension Optional {
    
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
    func or(_ defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
        guard let wrapped = try? unwrap() else {
            return defaultValue()
        }
        return wrapped
    }
    func or<T>(_ defaultValue: T, else transform: (Wrapped) -> T) -> T {
        guard let wrapped = try? unwrap() else {
            return defaultValue
        }
        return transform(wrapped)
    }
    func or<T>(_ defaultValue: T, else transform: @autoclosure () -> T) -> T {
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
