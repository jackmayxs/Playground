//
//  IndexPathPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/6/13.
//

import Foundation

extension IndexPath: ExpressibleByIntegerLiteral {
    
    /// 通过整型字面量创建IndexPath
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(row: value, section: 0)
    }
}

extension IndexPath: ExpressibleByStringLiteral {
    
    /// 通过字符串字面量创建IndexPath
    /// 例如: 0.1, 表示第0组第1项
    public init(stringLiteral value: StringLiteralType) {
        let components = value.components(separatedBy: ".")
        if components.count == 2 {
            if let section = components.first?.int, let row = components.last?.int {
                self.init(row: row, section: section)
            } else {
                self.init(row: 0, section: 0)
            }
        } else {
            self.init(row: 0, section: 0)
        }
    }
}
