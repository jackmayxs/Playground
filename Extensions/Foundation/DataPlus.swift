//
//  DataPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/8.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit

extension Data {
	var cfData: CFData {
		self as CFData
	}
	
	/// 转换为图片尺寸
	var imageSize: CGSize {
		guard let source = CGImageSourceCreateWithData(cfData, .none) else { return .zero }
		guard let image = CGImageSourceCreateImageAtIndex(source, 0, .none) else { return .zero }
		return CGSize(width: image.width, height: image.height)
	}
}
