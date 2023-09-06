//
//  SKSpriteNodePlus.swift
//  KnowLED
//
//  Created by Choi on 2023/9/1.
//

import UIKit
import SpriteKit

extension SKSpriteNode {
    
    /// 尺寸变动时更新尺寸
    /// - Parameter newSize: 新尺寸
    func reSizeIfNeeded(_ newSize: CGSize) {
        if size != newSize {
            size = newSize
        }
    }
}
