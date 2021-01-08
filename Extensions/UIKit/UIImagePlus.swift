//
//  UIImagePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit

extension UIImage {
	
	/// 启动图截图
	static var launchScreenSnapshot: UIImage? {
		guard let infoDict = Bundle.main.infoDictionary else { return .none }
		guard let nameValue = infoDict["UILaunchStoryboardName"] else { return .none }
		guard let name = nameValue as? String else { return .none }
		let storyboard = UIStoryboard(name: name, bundle: .none)
		guard let vc = storyboard.instantiateInitialViewController() else { return .none }
		let screenSize = UIScreen.main.bounds.size
		let screenScale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(screenSize, false, screenScale)
		guard let context = UIGraphicsGetCurrentContext() else { return .none }
		vc.view.layer.render(in: context)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	/// 图片二进制类型
	var data: Data? {
		if let data = pngData() {
			return data
		} else if let data = jpegData(compressionQuality: 1) {
			return data
		} else {
			return .none
		}
	}
	
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
