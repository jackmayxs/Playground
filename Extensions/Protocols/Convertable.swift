//
//  Convertable.swift
//  KnowLED
//
//  Created by Choi on 2024/9/29.
//

import Foundation

public protocol Convertable {
    func `as`<T>(_ type: T.Type) -> T?
}

extension Convertable {
    public func `as`<T>(_ type: T.Type) -> T? {
        self as? T
    }
}

extension NSObject: Convertable {}
extension Optional: Convertable {}

extension Error {
    public func `as`<T>(_ type: T.Type) -> T? {
        self as? T
    }
}
