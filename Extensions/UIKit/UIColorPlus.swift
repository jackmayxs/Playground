//
//  UIColorPlus.swift
//  ExtensionDemo
//
//  Created by Major on 2021/1/11.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK: - __________ Static __________
	
	/// 使用十六进制数字创建UIColor
	/// - Parameters:
	///   - hex: 十六进制数字颜色
	///   - alpha: 透明度
	/// - Returns: A new UIColor
    static func hex(_ hex: UInt32, alpha: CGFloat = 1) -> UIColor {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex & 0x0000FF       ) / divisor
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
	
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
