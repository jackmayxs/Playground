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
