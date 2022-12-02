//
//  ArrayPlus.swift
//  zeniko
//
//  Created by Choi on 2022/10/21.
//

import Foundation

extension Array {
    
    init(@ArrayBuilder<Element> _ itemsBuilder: () -> Self) {
        self.init(itemsBuilder())
    }
    
    public mutating func append(@ArrayBuilder<Element> _ builder: () -> [Element]) {
        let elements = builder()
        append(contentsOf: elements)
    }
    
    public func itemAt(_ index: Index) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
    
    public init(generating elementGenerator: (Int) -> Element, count: Int) {
        self = (0..<count).map(elementGenerator)
    }
    public init(generating elementGenerator: () -> Element, count: Int) {
        self = (0..<count).map { _ in
            elementGenerator()
        }
    }
}

// MARK: - Equatable Array
extension Array where Element: Equatable {
    
    @discardableResult
    /// 替换指定元素
    /// - Parameter newElement: 新元素
    /// - Returns: 是否替换成功
    public mutating func replace(
        with newElement: Element,
        if prediction: (_ old: Element, _ new: Element) -> Bool = { $0 == $1 }
    ) -> Bool {
        let index = firstIndex { oldElement in
            prediction(oldElement, newElement)
        }
        if let index {
            let range = index..<index + 1
            let updated = [newElement]
            replaceSubrange(range, with: updated)
            return true
        } else {
            append(newElement)
            return false
        }
    }
    
    @discardableResult
    /// 移除指定元素
    /// - Parameter element: 要移除的元素
    /// - Returns: 更新后的数组
    public mutating func remove(_ element: Element) -> Array {
        if let foundIndex = firstIndex(of: element) {
            remove(at: foundIndex)
        }
        return self
    }
}

// MARK: - Hashable Array
extension Array where Element : Hashable {
    
    mutating func appendUnique<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence {
        newElements.forEach { element in
            appendUnique(element)
        }
    }
    
    /// 添加唯一的元素
    /// - Parameter newElement: 遵循Hashable的元素
    mutating func appendUnique(_ newElement: Element) {
        let isNotUnique = contains { element in
            element.hashValue == newElement.hashValue
        }
        guard !isNotUnique else { return }
        append(newElement)
    }
    
    /// 合并唯一的元素 | 可用于reduce
    /// - Parameters:
    ///   - lhs: 数组
    ///   - rhs: 要添加的元素
    /// - Returns: 结果数组
    static func +> (lhs: Self, rhs: Element) -> Self {
        var result = lhs
        result.appendUnique(rhs)
        return result
    }
    
    /// 合并数组
    /// - Parameters:
    ///   - lhs: 原数组
    ///   - rhs: 新数组
    /// - Returns: 合并唯一元素的数组
    static func +> (lhs: Self, rhs: Self) -> Self {
        rhs.reduce(lhs, +>)
    }
    
    var set: Set<Element> {
        Set(self)
    }
}

// MARK: - ArraySlice
extension ArraySlice {
    
    /// 转换为Array
    var array: Array<Element> {
        Array(self)
    }
}
