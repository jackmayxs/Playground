//
//  CoreAnimation.swift
//  zeniko
//
//  Created by Choi on 2022/9/5.
//

import UIKit

extension CALayer {
    
    func addSublayers(@ArrayBuilder<CALayer> builder: () -> [CALayer]) {
        let subLayers = builder()
        subLayers.forEach { subLayer in
            addSublayer(subLayer)
        }
    }
    
    func setShadow(offsetX: Double, offsetY: Double, blur: CGFloat, color: UIColor, opacity: Float) {
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = CGSize(width: offsetX, height: offsetY)
        shadowRadius = blur
    }
    
    func setBorder(withColor color:CGColor, thickness:CGFloat) {
        self.borderColor = color
        self.borderWidth = thickness
    }
}
