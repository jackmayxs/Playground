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

struct GradientColor {
    let colorStops: [ColorStop]
    init(colorStops: [ColorStop]) {
        self.colorStops = colorStops
    }
    init(@ArrayBuilder<ColorStop> _ colorsBuilder: () -> [ColorStop]) {
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
    
    convenience init(@ArrayBuilder<ColorStop> _ colorsBuilder: () -> [ColorStop]) {
        self.init(frame: .zero)
        let gradient = GradientColor(colorsBuilder)
        let stops = gradient.colorStops.map(\.stop)
        let stopsAreLegal = stops.allSatisfy { stop in
            stop >= 0 && stop <= 1
        }
        if stopsAreLegal {
            gradientLayer.locations = stops.map(NSNumber.init)
        }
        setGradientColor(gradient)
    }
    
    func setGradientColor(_ gradientColor: GradientColor) {
        gradientLayer.colors = gradientColor.cgColors
    }

    func setDirection(_ vector: CGVector) {
        let points = vector.positivePoints
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vectors: [CGVector] = [.up, .down, .left, .right]
        setDirection(vectors.randomElement() ?? .topLeft)
    }
}

extension GradientView {
    
    /// 渐变图层
    var gradientLayer: GradientLayer {
        layer as! GradientLayer
    }
}
