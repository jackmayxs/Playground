//
//  ARGB.swift
//  KnowLED
//
//  Created by Choi on 2024/1/5.
//

import UIKit

struct ARGB {
    let alpha: Double
    let red: Double
    let green: Double
    let blue: Double
}

extension ARGB {
    
    static let black = ARGB(red: 0.0, green: 0.0, blue: 0.0)
    
    init(red: Double, green: Double, blue: Double) {
        self.alpha = 1.0
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.alpha = 1.0
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    var rgbArray: [Double] {
        [red, green, blue]
    }
}

extension ARGB: Comparable {
    
    /// 比较两个颜色
    static func < (lhs: ARGB, rhs: ARGB) -> Bool {
        let lRed = lhs.red, lGreen = lhs.green, lBlue = lhs.blue
        let rRed = rhs.red, rGreen = rhs.green, rBlue = rhs.blue
        if lRed != rRed {
            return lRed < rRed
        }
        else if lGreen != rGreen {
            return lGreen < rGreen
        }
        else if lBlue != rBlue {
            return lBlue < rBlue
        }
        else {
            return false
        }
    }
}
