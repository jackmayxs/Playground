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

typealias ColorStopsBuilder = () -> [ColorStop]

// MARK: - 渐变View
class GradientView: UIView {
    
    typealias GradientLayer = CAGradientLayer
    
    override class var layerClass: AnyClass { GradientLayer.self }
    
    convenience init() {
        self.init(direction: .right) {}
    }
    private(set) var colorStops: [ColorStop] = []
    init(direction: CGVector = .right, @ArrayBuilder<ColorStop> _ colorsBuilder: ColorStopsBuilder) {
        super.init(frame: .zero)
        /// 设置渐变色
        let stops = colorsBuilder()
        let stopsAreLegal = stops.allSatisfy { colorStop in
            colorStop.stop >= 0 && colorStop.stop <= 1
        }
        if stops.count > 0, stopsAreLegal {
            gradientLayer.locations = stops.map(NSNumber.init)
        } else {
            gradientLayer.locations = nil
        }
        setColorStops(stops)
        /// 设置方向
        setDirection(direction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refill(@ArrayBuilder<ColorStop> _ colorsBuilder: ColorStopsBuilder) {
        let colors = colorsBuilder()
        setColorStops(colors)
    }
    
    func setColorStops(_ colorStops: [ColorStop]) {
        self.colorStops = colorStops
        gradientLayer.colors = colorStops.map(\.color.cgColor)
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
