//
//  GradientView.swift
//  zeniko
//
//  Created by Choi on 2022/8/26.
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
        let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
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
        let stopsAreLegal = gradientColors.allSatisfy { colorStop in
            colorStop.stop >= 0 && colorStop.stop <= 1
        }
        if gradientColors.count > 0, stopsAreLegal {
            gradientLayer.locations = gradientColors.map(NSNumber.init)
        } else {
            gradientLayer.locations = nil
        }
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
        gradientLayer.colors = gradientColors.map(\.color.cgColor)
    }

    func setDirection(_ vector: CGVector) {
        let points = vector.positivePoints
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
    }
}

extension GradientView {
    
    /// 渐变图层
    var gradientLayer: GradientLayer {
        layer as! GradientLayer
    }
}
