//
//  UIColorPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/11.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

typealias Kelvin = CGFloat

extension UIColor {
    static let OxCCCCCC = 0xCCCCCC.uiColor
    static let OxEEEEEE = 0xEEEEEE.uiColor
    static let Ox999999 = 0x999999.uiColor
    static let Ox666666 = 0x666666.uiColor
    static let Ox555555 = 0x555555.uiColor
    static let Ox444444 = 0x444444.uiColor
    static let Ox333333 = 0x333333.uiColor
    static let Ox222222 = 0x222222.uiColor
}

extension UIColor {
    
    var hexString: String? {
        int.map { int in
            "#" + int.hexString
        }
    }
    
    /// 返回argb颜色
    var int: Int? {
        int(alphaIgnored: true)
    }
    
    func int(alphaIgnored: Bool = true) -> Int? {
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        let redComponent = components[0]
        let greenComponent = components[1]
        let blueComponent = components[2]
        /// 确保三原色都为有效数字
        if redComponent.isNaN || greenComponent.isNaN || blueComponent.isNaN { return nil }
        lazy var red = Int(redComponent * 255.0)
        lazy var green = Int(greenComponent * 255.0)
        lazy var blue = Int(blueComponent * 255.0)
        lazy var rgb = (red << 16) ^ (green << 8) ^ blue
        switch components.count {
        case 3:
            return rgb
        case 4:
            /// 透明度
            lazy var alpha = Int(components[3] * 255.0)
            /// 是否忽略透明通道
            return alphaIgnored ? rgb : (alpha << 24) ^ rgb
        default:
            return nil
        }
    }
    
    var hue: CGFloat {
        guard let hsba else { return 0.0 }
        return hsba.0
    }
    
    var hsba: (CGFloat, CGFloat, CGFloat, CGFloat)? {
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return nil }
        return (h, s, b, a)
    }
    
    /// 计算色温
    var kelvin: Kelvin? {
        guard let aRGB else { return nil }
        let red = aRGB.r
        let green = aRGB.g
        let blue = aRGB.b
        let temp = (0.23881 * red + 0.25499 * green - 0.58291 * blue) / (0.11109 * red - 0.85406 * green + 0.52289 * blue)
        let colorTemperature = 449 * pow(temp, 3) + 3525 * pow(temp, 2) + 6823.3 * temp + 5520.33
        return colorTemperature
    }
    
    var aRGB: (a: CGFloat, r: CGFloat, g: CGFloat, b: CGFloat)? {
        var a: CGFloat = 0.0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (a, r, g, b)
    }
    
    /// 和UIColor相互转换不一致,需要校准
    var xy: XY {
        let cgColor = cgColor
        guard let components = cgColor.components else { return .zero }
        var red = 1.0
        var green = 1.0
        var blue = 1.0
        if cgColor.numberOfComponents == 4 {
            /// Full color
            red = components[0]
            green = components[1]
            blue = components[2]
        } else if cgColor.numberOfComponents == 2 {
            // Greyscale color
            red = components[0]
            green = components[0]
            blue = components[0]
        }
        
        let linearRGB = [red, green, blue].map {
            pow($0, 2.2)
        }
        
        lazy var appleRGB = Array<[Double]> {
            [0.4497288, 0.3162486, 0.1844926]
            [0.2446525, 0.6720283, 0.0833192]
            [0.0251848, 0.1411824, 0.9224628]
        }
        
        lazy var sRGB = Array<[Double]> {
            [0.4124564, 0.3575761, 0.1804375]
            [0.2126729, 0.7151522, 0.0721750]
            [0.0193339, 0.1191920, 0.9503041]
        }
        
        lazy var bestRGB = Array<[Double]> {
            [0.6326696, 0.2045558, 0.1269946]
            [0.2284569, 0.7373523, 0.0341908]
            [0.0000000, 0.0095142, 0.8156958]
        }
        
        lazy var adobeRGB1998 = Array<[Double]> {
            [0.5767309, 0.1855540, 0.1881852]
            [0.2973769, 0.6273491, 0.0752741]
            [0.0270343, 0.0706872, 0.9911085]
        }
        
        lazy var wideGamutRGB = Array<[Double]> {
            [0.7161046, 0.1009296, 0.1471858]
            [0.2581874, 0.7249378, 0.0168748]
            [0.0000000, 0.0517813, 0.7734287]
        }
        
        let M = bestRGB
        
        let xyz = linearRGB * M
        let xyzSum = xyz.reduce(0.0, +)
        let resultXYZ = xyz.map {
            $0 / xyzSum
        }
        guard resultXYZ.count >= 2 else { return .zero }
        let x = resultXYZ[0]
        let y = resultXYZ[1]
        return XY(x: x, y: y)
    }
    
    /// 从色温创建颜色
    /// - Parameter kelvin: 色温 | 单位: 开尔文
    /// - Returns: UIColor对象
    static func fromTemperature(_ kelvin: Kelvin) -> UIColor {
        UIColor(temperature: kelvin)
    }
    
    /// 从色温创建颜色
    /// - Parameter temperature: 色温 | 取值范围: (1000K to 40000K)
    /// https://github.com/davidf2281/ColorTempToRGB
    convenience init(temperature: Kelvin) {
        
        func clamp(_ value: CGFloat) -> CGFloat {
            value > 255 ? 255 : (value < 0 ? 0 : value);
        }
        
        func componentsForColorTemperature(temperature: Kelvin) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
            let percentKelvin = temperature / 100;
            let red, green, blue: CGFloat
            red = clamp(percentKelvin <= 66 ? 255 : (329.698727446 * pow(percentKelvin - 60, -0.1332047592)));
            green = clamp(percentKelvin <= 66 ? (99.4708025861 * log(percentKelvin) - 161.1195681661) : 288.1221695283 * pow(percentKelvin - 60, -0.0755148492));
            blue = clamp(percentKelvin >= 66 ? 255 : (percentKelvin <= 19 ? 0 : 138.5177312231 * log(percentKelvin - 10) - 305.0447927307));
            return (red: red / 255, green: green / 255, blue: blue / 255)
        }
        
        let components = componentsForColorTemperature(temperature: temperature)
        
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
    
    /// XY坐标创建颜色
    /// - Parameters:
    ///   - x: 0...0.8
    ///   - y: 0...0.9
    convenience init(x: Double, y: Double) {
        let z = 1.0 - x - y
        
        let Y = 1.0
        let X = (Y / y) * x
        let Z = (Y / y) * z
        
        /// sRGB D65 CONVERSION
        var r = X  * 3.2406 - Y * 1.5372 - Z * 0.4986
        var g = -X * 0.9689 + Y * 1.8758 + Z * 0.0415
        var b = X  * 0.0557 - Y * 0.2040 + Z * 1.0570
        
        if r > b && r > g && r > 1.0 {
            // red is too big
            g = g / r
            b = b / r
            r = 1.0
        } else if g > b && g > r && g > 1.0 {
            // green is too big
            r = r / g
            b = b / g
            g = 1.0
        } else if b > r && b > g && b > 1.0 {
            // blue is too big
            r = r / b
            g = g / b
            b = 1.0
        }
        // Apply gamma correction
        r = r <= 0.0031308 ? 12.92 * r : (1.0 + 0.055) * pow(r, (1.0 / 2.4)) - 0.055
        g = g <= 0.0031308 ? 12.92 * g : (1.0 + 0.055) * pow(g, (1.0 / 2.4)) - 0.055
        b = b <= 0.0031308 ? 12.92 * b : (1.0 + 0.055) * pow(b, (1.0 / 2.4)) - 0.055
        if r > b && r > g {
            // red is biggest
            if (r > 1.0) {
                g = g / r
                b = b / r
                r = 1.0
            }
        } else if g > b && g > r {
            // green is biggest
            if g > 1.0 {
                r = r / g
                b = b / g
                g = 1.0
            }
        } else if b > r && b > g {
            // blue is biggest
            if b > 1.0 {
                r = r / b
                g = g / b
                b = 1.0
            }
        }
        /// 限制在0...1范围内避免出现负值导致错误
        let range = (0.0...1.0)
        let cr = range.constrainedValue(r)
        let cg = range.constrainedValue(g)
        let cb = range.constrainedValue(b)
        self.init(red: cr, green: cg, blue: cb, alpha: 1.0)
    }
    
    convenience init(hue: Double) {
        self.init(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    @available(iOS 13.0, *)
    convenience init(dark: UIColor, light: UIColor) {
        self.init { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    /// 使用RGB创建UIColor | 用于某些情况下使用.map方法快速映射成UIColor
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 使用RGB创建UIColor | 用于某些情况下使用.map方法快速映射成UIColor | 用于某些情况下使用Double类型作输入参数
    convenience init(red: Double, green: Double, blue: Double) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// 添加透明色
    static func +(lhs: UIColor, rhs: CGFloat) -> UIColor {
        lhs.withAlphaComponent(rhs)
    }
    
	/// 生成一个随机颜色
    static var random: UIColor {
        UIColor(red: .randomPercent, green: .randomPercent, blue: .randomPercent, alpha: 1)
    }
    
    static func hex(_ hexValue: Int) -> UIColor {
        hexValue.uiColor
    }
    
    // MARK: - __________ Instance __________
    func uiImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        setFill()
        UIRectFill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func viewWithSize(_ size: CGFloat, constrained: Bool = true) -> UIView {
        view(UIView.self, size: size, constrained: constrained)
    }
    
    func view<T>(_ type: T.Type, size: CGFloat, constrained: Bool = true) -> T where T: UIView {
        view(type, width: size, height: size, constrained: constrained)
    }
    
    func view<T>(_ type: T.Type, width: CGFloat, height: CGFloat, constrained: Bool = true) -> T where T: UIView {
        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: .zero, size: size)
        let view = T(frame: rect)
        view.backgroundColor = self
        if constrained {
            view.fix(width: width, height: height)
        }
        return view
    }
}

extension Int {
	
    @available(iOS 13.0, *)
    var cgColor: CGColor {
		guard let aRGB else { return UIColor.clear.cgColor }
		return CGColor(red: aRGB.r, green: aRGB.g, blue: aRGB.b, alpha: aRGB.a)
	}
	
	var uiColor: UIColor {
		guard let aRGB else { return .clear }
		return UIColor(red: aRGB.r, green: aRGB.g, blue: aRGB.b, alpha: aRGB.a)
	}
    
    /// 整型 -> ARGB
	var aRGB: (a: CGFloat, r: CGFloat, g: CGFloat, b: CGFloat)? {
        let maxRGB = 0xFF_FF_FF
        let maxARGB = 0xFF_FF_FF_FF
        switch self {
        case 0...maxRGB:
            /// 不带透明度的情况
            let red     = CGFloat((self & 0xFF_00_00) >> 16) / 0xFF
            let green   = CGFloat((self & 0x00_FF_00) >>  8) / 0xFF
            let blue    = CGFloat( self & 0x00_00_FF       ) / 0xFF
            return (1.0, red, green, blue)
        case maxRGB.number...maxARGB:
            /// 带透明度的情况
            let alpha   = CGFloat((self & 0xFF_00_00_00) >> 24) / 0xFF
            let red     = CGFloat((self & 0x00_FF_00_00) >> 16) / 0xFF
            let green   = CGFloat((self & 0x00_00_FF_00) >>  8) / 0xFF
            let blue    = CGFloat( self & 0x00_00_00_FF       ) / 0xFF
            return (alpha, red, green, blue)
        default:
            /// 其他情况
            return nil
        }
	}
}

extension String {
    
    /// 从十六进制字符串转换颜色
    var uiColor: UIColor {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        if #available(iOS 13.0, *) {
            guard let int = scanner.scanInt(representation: .hexadecimal) else { return .clear }
            return int.uiColor
        } else {
            var uint: UInt64 = 0
            scanner.scanHexInt64(&uint)
            return Int(uint).uiColor
        }
    }
}
