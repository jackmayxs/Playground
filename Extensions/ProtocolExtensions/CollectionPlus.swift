//
//  CollectionPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

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
    
    func filledOr(_ defaultValue: Self) -> Self {
        isNotEmpty ? self : defaultValue
    }
    
    /// 如果为空则返回nil
    var filledOrNil: Self? {
        isNotEmpty ? self : nil
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
}
