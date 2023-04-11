//
//  ProtocolExtensions.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/8/28.
//  Copyright © 2021 Choi. All rights reserved.
//

import Foundation

// MARK: - __________ Equatable __________
extension Equatable {
	var optional: Self? { self }
}

// MARK: - __________ Collection __________
extension Collection {
    
    func removeDuplicates<Value>(for keyPath: KeyPath<Element, Value>) -> [Element] where Value: Equatable {
        removeDuplicates { element1, element2 in
            element1[keyPath: keyPath] == element2[keyPath: keyPath]
        }
    }
    
    func removeDuplicates(includeElement: (Element, Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { element in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
    
    /// 如果为空则返回nil
    var filledOrNil: Self? {
        isNotEmpty ? self : nil
    }
    
	var isNotEmpty: Bool {
		!isEmpty
	}
}
// MARK: - __________ Sequence __________
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
