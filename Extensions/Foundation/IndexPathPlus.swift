//
//  IndexPathPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/13.
//

import Foundation

extension IndexPath {
    
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
