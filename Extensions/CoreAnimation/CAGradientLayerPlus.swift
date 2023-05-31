//
//  CAGradientLayerPlus.swift
//
//  Created by Choi on 2022/10/8.
//

import UIKit

// MARK: - 渐变色封装
struct ColorStop {
    let color: UIColor
    let stop: Double
    init(color: UIColor, stop: Double = -1) {
        self.color = color
        self.stop = stop
    }
    
    /// 从HUE创建对象
    /// - Parameters:
    ///   - hue: 色相 (范围: 0 - 1)
    static func fromHue(_ hue: Double) -> ColorStop {
        let color = UIColor(hue: hue)
        return self.init(color: color)
    }
}

extension UIColor {
    var colorStop: ColorStop {
        ColorStop(color: self)
    }
}

typealias GradientColors = [ColorStop]
typealias GradientColorsBuilder = () -> GradientColors

// MARK: - 渐变图层封装
extension CAGradientLayer {
    
    convenience init(direction: CGVector = .right, @ArrayBuilder<ColorStop> _ gradientBuilder: GradientColorsBuilder = { [] }) {
        self.init()
        /// 设置渐变色
        let gradientColors = gradientBuilder()
        setColors(gradientColors)
        /// 设置方向
        setDirection(direction)
    }
    
    func refill(@ArrayBuilder<ColorStop> _ gradientBuilder: GradientColorsBuilder) {
        let colors = gradientBuilder()
        setColors(colors)
    }
    
    func setDirection(_ vector: CGVector) {
        let points = vector.positivePoints
        startPoint = points.start
        endPoint = points.end
    }
    
    func setColors(_ gradientColors: GradientColors) {
        colors = gradientColors.map(\.color.cgColor)
        
        /// 设置渐变图层颜色停顿位置
        let stopsAreLegal = gradientColors.allSatisfy { colorStop in
            colorStop.stop >= 0 && colorStop.stop <= 1
        }
        if gradientColors.count > 0, stopsAreLegal {
            locations = gradientColors.map(\.stop).map(NSNumber.init)
        } else {
            locations = nil
        }
    }
}
