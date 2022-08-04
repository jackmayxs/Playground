//
//  UIColorPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/11.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIColor {
    static let OxCCCCCC = 0xCCCCCC.uiColor
    static let Ox999999 = 0x999999.uiColor
    static let Ox666666 = 0x666666.uiColor
    static let Ox333333 = 0x333333.uiColor
}

extension UIColor {
	
	/// 生成一个随机颜色
    static var random: UIColor {
        UIColor(red: .random, green: .random, blue: .random, alpha: 1)
    }
    // MARK: - __________ Instance __________
    func viewWithSize(_ size: CGFloat) -> UIView {
        view(UIView.self, size: size)
    }
    
    func view<T>(_ type: T.Type, size: CGFloat) -> T where T: UIView {
        view(type, width: size, height: size)
    }
    
    func view<T>(_ type: T.Type, width: CGFloat, height: CGFloat) -> T where T: UIView {
        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: .zero, size: size)
        let view = T(frame: rect)
        view.backgroundColor = self
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
}

extension Int {
	
    @available(iOS 13.0, *)
    var cgColor: CGColor {
		guard let argb = argb else { return UIColor.clear.cgColor }
		return CGColor(red: argb.r, green: argb.g, blue: argb.b, alpha: argb.a)
	}
	
	var uiColor: UIColor {
		guard let argb = argb else { return .clear }
		return UIColor(red: argb.r, green: argb.g, blue: argb.b, alpha: argb.a)
	}
	
	var argb: (a: CGFloat, r: CGFloat, g: CGFloat, b: CGFloat)? {
		guard 0...0xFF_FF_FF_FF ~= self else { return nil }
		// 带透明度的情况
		if self > 0xFF_FF_FF {
			let alpha   = CGFloat((self & 0xFF_00_00_00) >> 24) / 0xFF
			let red     = CGFloat((self & 0x00_FF_00_00) >> 16) / 0xFF
			let green   = CGFloat((self & 0x00_00_FF_00) >>  8) / 0xFF
			let blue    = CGFloat( self & 0x00_00_00_FF       ) / 0xFF
			return (alpha, red, green, blue)
		}
		// 不带透明度的情况
		else {
			let red     = CGFloat((self & 0xFF_00_00) >> 16) / 0xFF
			let green   = CGFloat((self & 0x00_FF_00) >>  8) / 0xFF
			let blue    = CGFloat( self & 0x00_00_FF       ) / 0xFF
			return (1.0, red, green, blue)
		}
	}
}
