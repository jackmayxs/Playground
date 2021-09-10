//
//  UIImagePlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2020/7/29.
//  Copyright © 2020 Choi. All rights reserved.
//

import UIKit
import Photos

extension UIImage {
	
	/// 给图片着色
	/// - Parameters:
	///   - tintColor: 要改变的颜色
	///   - blendMode: 着色模式
	/// - Returns: 着色后的图片
	func imageWith(tintColor: UIColor, blendMode: CGBlendMode = .overlay) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
		defer {
			UIGraphicsEndImageContext()
		}
		// 定义画布
		let canvas = CGRect(origin: .zero, size: size)
		tintColor.setFill()
		UIRectFill(canvas)
		draw(in: canvas, blendMode: blendMode, alpha: 1.0)
		if blendMode != .destinationIn {
			draw(in: canvas, blendMode: .destinationIn, alpha: 1.0)
		}
		return UIGraphicsGetImageFromCurrentImageContext()
		/* 备注:
		因为每次使用此方法绘图时，都使用了CG的绘制方法
		这就意味着每次调用都会是用到CPU的Offscreen drawing
		大量使用的话可能导致性能的问题（主要对于iPhone 3GS或之前的设备，可能同时处理大量这样的绘制调用的能力会有不足）。
		原文地址: https://onevcat.com/2013/04/using-blending-in-ios/
		*/
	}
	
	//将图片缩放成指定尺寸（多余部分自动删除）
	func scaled(to newSize: CGSize) -> UIImage? {
		//计算比例
		let aspectWidth  = newSize.width/size.width
		let aspectHeight = newSize.height/size.height
		let aspectRatio = max(aspectWidth, aspectHeight)
		
		//图片绘制区域
		var canvas = CGRect.zero
		canvas.size.width  = size.width * aspectRatio
		canvas.size.height = size.height * aspectRatio
		canvas.origin.x = (newSize.width - size.width * aspectRatio) / 2.0
		canvas.origin.y = (newSize.height - size.height * aspectRatio) / 2.0
		
		//绘制并获取最终图片
		UIGraphicsBeginImageContext(newSize)
		defer {
			UIGraphicsEndImageContext()
		}
		draw(in: canvas)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	func saveToPhotoLibrary(completionHandler: @escaping (Bool, Error?) -> Void) {
		PHPhotoLibrary.shared().performChanges {
			PHAssetChangeRequest.creationRequestForAsset(from: self)
		} completionHandler: { result, error in
			DispatchQueue.main.async {
				completionHandler(result, error)
			}
		}
	}
	
	func expandedImage(with insets: UIEdgeInsets) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size + insets, false, scale)
		let origin = CGPoint(x: insets.left, y: insets.top)
		draw(at: origin)
		defer {
			UIGraphicsEndImageContext()
		}
		return UIGraphicsGetImageFromCurrentImageContext().ifNil(self)
	}
	
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
