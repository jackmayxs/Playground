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
        guard count == 2 else {
            assertionFailure("只处理两层深的IndexPath. 单个Index不多见. 多个Path的情况需要特殊处理")
            return .empty
        }
        return IndexSet(integer: section)
    }
    
    /// item转换成IndexSet
    var itemIndexSet: IndexSet {
        guard count == 2 else {
            assertionFailure("只处理两层深的IndexPath. 单个Index不多见. 多个Path的情况需要特殊处理")
            return .empty
        }
        return IndexSet(integer: item)
    }
    
    /// 在自身的基础上对item/row进行偏移
    func offset(_ offset: Int) -> IndexPath {
        guard offset >= 0 else { return self }
        return IndexPath(item: item + offset, section: section)
    }
    
    static func +(lhs: IndexPath, rhs: Int) -> IndexPath {
        lhs.offset(rhs)
    }
}

extension IndexPath: ExpressibleByIntegerLiteral {
    
    /// 通过整型字面量创建IndexPath
    /// 另外还可以通过数组字面量创建IndexPath: [0, 1] 注: 只能是两个整型元素, 表示第0组第1个
    public init(integerLiteral literal: IntegerLiteralType) {
        self.init(row: literal, section: 0)
    }
}

extension Sequence where Element == IndexPath {
    
    /// 将所有IndexPath的section放入IndexSet
    var sectionIndexSet: IndexSet {
        reduce(into: IndexSet.empty) { accumulation, next in
            guard next.count == 2 else {
                assertionFailure("只处理两层深的IndexPath. 单个Index不多见. 多个Path的情况需要特殊处理")
                return
            }
            accumulation.insert(next.section)
        }
    }
    
    /// 将所有IndexPath的item放入IndexSet
    var itemIndexSet: IndexSet {
        do {
            var sectionSet = Set<Int>.empty
            return try reduce(into: IndexSet.empty) { accumulation, next in
                guard next.count == 2 else {
                    assertionFailure("只处理两层深的IndexPath. 单个Index不多见. 多个Path的情况需要特殊处理")
                    return
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
