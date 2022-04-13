//
//  SuperButton.swift
//  ExtensionDemo
//
//  Created by Major on 2022/4/13.
//  Copyright © 2022 Choi. All rights reserved.
//

import UIKit

class SuperButton: UIButton {

   
	/// 可以根据contentEdgeInsets自动适配自身大小
	override var intrinsicContentSize: CGSize {

		let backgroundImageSize = currentBackgroundImage?.size ?? .zero
		var regularSize: CGSize {
			if imageSize == .zero {
				return titleSize + contentEdgeInsets
			} else if titleSize == .zero {
				return imageSize + contentEdgeInsets
			} else {
				// 初始化size
				var size = CGSize.zero
				// 计算宽高
				switch imagePlacement  {
				case .top, .bottom:
					size.width = max(imageWidth, titleWidth)
					size.height = imageHeight + imagePadding + titleHeight
				case .left, .right:
					size.width = imageWidth + imagePadding + titleWidth
					size.height = max(imageHeight, titleHeight)
				}
				return size + contentEdgeInsets
			}
		}

		return useBackgroundImageSize ? backgroundImageSize : regularSize
	}

}
