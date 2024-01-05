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
