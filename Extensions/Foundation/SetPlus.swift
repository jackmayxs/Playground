//
//  SetPlus.swift
//
//  Created by Choi on 2022/10/19.
//

import Foundation

infix operator +- : MultiplicationPrecedence

extension Set {
    
    var array: Array<Element> {
        Array(self)
    }
    
    public mutating func insert(@ArrayBuilder<Element> _ builder: () -> [Element]) {
        let elements = builder()
        formUnion(elements)
    }
    
    /// 添加新元素 | 慎用(使用不当可能导致未能更新元素其他属性的问题)
    /// - Parameters:
    ///   - other: 新元素序列
    ///   - keyPath: 指定要对比的KeyPath
    public mutating func formUnion<S>(_ other: S, identifiedBy keyPath: KeyPath<Element, some Equatable>) where Element == S.Element, S: Sequence {
        for element in other {
            let exist = contains { elementInSet in
                elementInSet[keyPath: keyPath] == element[keyPath: keyPath]
            }
            if exist {
                continue
            } else {
                self.insert(element)
            }
        }
    }
}


extension Set where Element: Hashable {
    
    /// 交集
    static func ^ (lhs: Set<Element>, rhs: Set<Element>) -> Set<Element> {
        lhs.intersection(rhs)
    }
    
    /// 并集
    static func + (lhs: Set<Element>, rhs: Set<Element>) -> Set<Element> {
        lhs.union(rhs)
    }
    
    /// 相对差集
    /// 在集合A中却不在集合B中的集合，如：「1，2，3」 - 「2，3，4」= 「1」；「2，3，4」 - 「1，2，3」= 「4」
    static func - (lhs: Set<Element>, rhs: Set<Element>) -> Set<Element> {
        lhs.subtracting(rhs)
    }
    
    /// 相对差
    /// 只在集合A及B中的其中一个出现，没有在其交集中出现的元素
    /// 即并集减去交集（A∪B)\(A∩B）。如：「1，2，3」 +- 「2，3，4」= 「1，4」
    static func +- (lhs: Set<Element>, rhs: Set<Element>) -> Set<Element> {
        lhs.symmetricDifference(rhs)
    }
}
