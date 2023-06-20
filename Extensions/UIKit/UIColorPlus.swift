//
//  UIColorPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/11.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

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
    
    /// 返回argb颜色
    var int: Int? {
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        switch components.count {
        case 3:
            return (red << 16) ^ (green << 8) ^ blue
        case 4:
            let alpha = Int(components[3] * 255.0)
            return (alpha << 24) ^ (red << 16) ^ (green << 8) ^ blue
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
