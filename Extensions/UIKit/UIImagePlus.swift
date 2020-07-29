//
//  UIImagePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 圆角图片
    var roundImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        let rect = CGRect(origin: .zero, size: size)
        ctx.addEllipse(in: rect)
        ctx.clip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 圆角图片(用贝塞尔曲线)创建
    func roundImage(clip roundingCorners: UIRectCorner = .allCorners,
                    cornerRadii: CGFloat? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: .zero, size: size)
        let defaultRadii = cornerRadii ?? size.height/2
        let cornerSize = CGSize(width: defaultRadii, height: defaultRadii)
        UIBezierPath(roundedRect: rect,
                     byRoundingCorners: roundingCorners,
                     cornerRadii: cornerSize).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
