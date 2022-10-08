//
//  GradientView.swift
//  zeniko
//
//  Created by Choi on 2022/8/26.
//

import UIKit

// MARK: - 渐变View
class GradientView: UIView {
    
    typealias GradientLayer = CAGradientLayer
    
    override class var layerClass: AnyClass { GradientLayer.self }
    
    convenience init() {
        self.init(direction: .right) {}
    }
    private(set) var gradientColors: GradientColors = []
    init(direction: CGVector = .right, @ArrayBuilder<ColorStop> _ gradientBuilder: GradientColorsBuilder) {
        super.init(frame: .zero)
        /// 设置渐变色
        let gradientColors = gradientBuilder()
        setGradientColors(gradientColors)
        /// 设置方向
        setDirection(direction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill(@ArrayBuilder<ColorStop> _ gradientBuilder: GradientColorsBuilder) {
        let colors = gradientBuilder()
        setGradientColors(colors)
    }
    
    func setGradientColors(_ gradientColors: GradientColors) {
        self.gradientColors = gradientColors
        gradientLayer.setColors(gradientColors)
    }

    func setDirection(_ vector: CGVector) {
        gradientLayer.setDirection(vector)
    }
}

extension GradientView {
    
    /// 渐变图层
    var gradientLayer: GradientLayer {
        layer as! GradientLayer
    }
}
