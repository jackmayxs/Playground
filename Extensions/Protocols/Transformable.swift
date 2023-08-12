//
//  Transformable.swift
//  KnowLED
//
//  Created by Choi on 2023/8/12.
//

import Foundation

/// 转换自身为另一种类型
/// - Parameter transformer: 具体转换的实现过程
/// - Returns: 返回转换之后的实例
protocol Transformable {
    associatedtype E
    func transform<T>(_ transformer: (E) -> T) -> T
}

extension Transformable {
    func transform<T>(_ transformer: (Self) -> T) -> T {
        transformer(self)
    }
}

extension NSObject: Transformable {}
extension Set: Transformable {}
extension Array: Transformable {}
extension Dictionary: Transformable {}
extension DateComponents: Transformable {}
extension Calendar: Transformable {}
