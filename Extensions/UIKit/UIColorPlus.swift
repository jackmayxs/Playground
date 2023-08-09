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
        lazy var red = Int(components[0] * 255.0)
        lazy var green = Int(components[1] * 255.0)
        lazy var blue = Int(components[2] * 255.0)
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
    
    
    /// 和UIColor相互转换不一致,需要校准
    var xy: (x: Double, y: Double) {
        lazy var zero = (0.0, 0.0)
        let cgColor = cgColor
        guard let components = cgColor.components else { return zero }
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
        // Apply gamma correction
        let r = (red   > 0.04045) ? pow((red   + 0.055) / (1.0 + 0.055), 2.4) : (red   / 12.92)
        let g = (green > 0.04045) ? pow((green + 0.055) / (1.0 + 0.055), 2.4) : (green / 12.92)
        let b = (blue  > 0.04045) ? pow((blue  + 0.055) / (1.0 + 0.055), 2.4) : (blue  / 12.92)
        
        // Wide gamut conversion D65
        let X = r * 0.649926 + g * 0.103455 + b * 0.197109
        //let Y = r * 0.234327 + g * 0.743075 + b * 0.022598
        let Y = 1.0
        let Z = r * 0.0000000 + g * 0.053077 + b * 1.035763
        
        var cx = X / (X + Y + Z)
        var cy = Y / (X + Y + Z)
        if cx.isNaN {
            cx = 0.0
        }
        if cy.isNaN {
            cy = 0.0
        }
        return (cx, cy)
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
        self.init(red: r, green: g, blue: b, alpha: 1.0)
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
