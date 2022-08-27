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
}

extension Array where Element == ColorStop {
    var gradientColor: GradientColor {
        GradientColor(colorStops: self)
    }
}

typealias ColorStopsBuilder = () -> [ColorStop]

struct GradientColor {
    let colorStops: [ColorStop]
    init(colorStops: [ColorStop]) {
        self.colorStops = colorStops
    }
    init(@ArrayBuilder<ColorStop> _ colorsBuilder: ColorStopsBuilder) {
        let colors = colorsBuilder()
        self.init(colorStops: colors)
    }
    var cgColors: [CGColor] {
        colorStops.map(\.color.cgColor)
    }
}

// MARK: - 渐变View
class GradientView: UIView {
    
    typealias GradientLayer = CAGradientLayer
    
    override class var layerClass: AnyClass { GradientLayer.self }
    
    convenience init() {
        self.init(direction: .right) {}
    }
    init(direction: CGVector = .right, @ArrayBuilder<ColorStop> _ colorsBuilder: ColorStopsBuilder) {
        super.init(frame: .zero)
        /// 设置渐变色
        let gradient = GradientColor(colorsBuilder)
        let stops = gradient.colorStops.map(\.stop)
        let stopsAreLegal = stops.allSatisfy { stop in
            stop >= 0 && stop <= 1
        }
        if stops.count > 0, stopsAreLegal {
            gradientLayer.locations = stops.map(NSNumber.init)
        } else {
            gradientLayer.locations = nil
        }
        setGradientColor(gradient)
        /// 设置方向
        setDirection(direction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill(@ArrayBuilder<ColorStop> _ colorsBuilder: ColorStopsBuilder) {
        let colors = colorsBuilder()
        setGradientColor(colors.gradientColor)
    }
    
    func setGradientColor(_ gradientColor: GradientColor) {
        gradientLayer.colors = gradientColor.cgColors
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
