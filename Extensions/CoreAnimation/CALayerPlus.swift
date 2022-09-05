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
}
