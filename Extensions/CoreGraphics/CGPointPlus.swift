//
//  CGPointPlus.swift
//  KnowLED
//
//  Created by Choi on 2023/7/25.
//

import UIKit
import GLKit

extension CGPoint {
    
    var isZero: Bool {
        self == .zero
    }
    
    func point(newX: CGFloat) -> CGPoint {
        CGPoint(x: newX, y: y)
    }
    
    func point(newY: CGFloat) -> CGPoint {
        CGPoint(x: x, y: newY)
    }
    
    /// 计算和另外一个点之间的距离 | 利用勾股定理: 两直角边的平方和开平方得出斜边长度
    /// - Parameter another: 另外一个点
    /// - Returns: 距离
    func distance(from another: CGPoint) -> CGFloat {
        sqrt(pow(x - another.x, 2.0) + pow(y - another.y, 2.0))
    }
}

extension CGPoint {
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        GLKVector2MultiplyScalar(lhs.glkVector2, rhs.float).cgPoint
    }
    
    var glkVector2: GLKVector2 {
        GLKVector2Make(x.float, y.float)
    }
}

extension GLKVector2 {
    
    var cgPoint: CGPoint {
        CGPoint(x: x.cgFloat, y: y.cgFloat)
    }
}
