//
//  CGColorPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/11.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension CGColor {
    static func hex(_ hex: UInt32, alpha: CGFloat = 1) -> CGColor {
        UIColor.hex(hex, alpha: alpha).cgColor
    }
}
