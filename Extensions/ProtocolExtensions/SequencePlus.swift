//
//  SequencePlus.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

extension Sequence where Iterator.Element: OptionalType {
    var unwrapped: [Iterator.Element.Wrapped] {
        compactMap(\.optionalValue)
    }
}

extension Sequence where Self: ExpressibleByArrayLiteral {
    
    /// 空序列
    static var empty: Self {
        []
    }
}

extension Sequence {
    func `as`<T>(_ type: T.Type) -> [T] {
        compactMap { element in
            element as? T
        }
    }
}

extension Sequence where Element: Hashable {
    var set: Set<Element> {
        Set(self)
    }
}
