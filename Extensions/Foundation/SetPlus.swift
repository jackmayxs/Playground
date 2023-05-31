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
