//
//  SKSpriteNodePlus.swift
//  KnowLED
//
//  Created by Choi on 2023/9/1.
//

import UIKit
import SpriteKit

extension SKSpriteNode {
    func reposition(to origin: CGPoint, changedSize: CGSize? = nil, test: Int? = nil) {
        if let changedSize {
            size = changedSize
        }
        reposition(to: origin, other: test)
    }
}
