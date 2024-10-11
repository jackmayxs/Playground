//
//  IndexPathPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/13.
//

import Foundation

extension IndexPath {
    
    /// section转换成IndexSet
    var sectionIndexSet: IndexSet {
        guard count >= 1 else { return .empty }
        return IndexSet(integer: section)
    }
    
    /// row转换成IndexSet
    var rowIndexSet: IndexSet {
        guard count >= 2 else { return .empty }
        return IndexSet(integer: row)
    }
    
    /// item转换成IndexSet
    var itemIndexSet: IndexSet {
        guard count >= 2 else { return .empty }
        return IndexSet(integer: item)
    }
}

extension IndexPath: ExpressibleByIntegerLiteral {
    
    /// 通过整型字面量创建IndexPath
    public init(integerLiteral path: IntegerLiteralType) {
        /// 通过数组字面量创建IndexPath: [0, 1] 注: 只能是两个整型元素, 表示第0组第1个
        self.init(arrayLiteral: 0, path)
    }
}

extension Sequence where Element == IndexPath {
    
    /// 将所有IndexPath的section放入IndexSet
    var sectionIndexSet: IndexSet {
        reduce(into: IndexSet.empty) { accumulation, next in
            guard let section = next.first else { return }
            accumulation.insert(section)
        }
    }
    
    /// 将所有IndexPath的item放入IndexSet
    var itemIndexSet: IndexSet {
        do {
            var sectionSet = Set<Int>.empty
            return try reduce(into: IndexSet.empty) { accumulation, next in
                guard next.count >= 2 else {
                    return dprint("Path深度不足")
                }
                sectionSet.insert(next.section)
                if sectionSet.count > 1 {
                    throw "Multiple section items in one IndexSet don't make sense."
                }
                accumulation.insert(next.item)
            }
        } catch {
            assertionFailure("Error: \(error)")
            return .empty
        }
    }
}
