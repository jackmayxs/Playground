//
//  CollectionPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

extension Collection {
    
    /// 根据KeyPath过滤掉重复的元素
    /// - Parameter keyPath: 元素的KeyPath
    /// - Returns: 无重复元素的数组
    func removeDuplicates<Value>(for keyPath: KeyPath<Element, Value>) -> [Element] where Value: Equatable {
        removeDuplicates { element1, element2 in
            element1[keyPath: keyPath] == element2[keyPath: keyPath]
        }
    }
    
    /// 移除重复项
    /// - Parameter includeElement: 判断是否重复的回调
    /// - Returns: 无重复元素的数组
    func removeDuplicates(includeElement: (Element, Element) -> Bool) -> [Element] {
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
