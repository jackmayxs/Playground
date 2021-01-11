//
//  ExtensionButton.swift
//  
//
//  Created by Choi on 2020/7/22.
//

import UIKit

extension UIButton {
	
	enum ImageTitleStyle: Int {
		case ㊤㊦
		case ㊧㊨
		case ㊦㊤
		case ㊨㊧
	}
	
	private struct AssociatedObjectKeys {
		static var ImageTitleSpacingKey = "ImageTitleSpacingKey"
		static var ImageTitleStyleKey = "ImageTitleStyleKey"
	}
	
	// MARK: - Properties
	
	private(set) var imageTitleStyle: ImageTitleStyle {
		set(style) {
			objc_setAssociatedObject(self, &AssociatedObjectKeys.ImageTitleStyleKey, style.rawValue, .OBJC_ASSOCIATION_ASSIGN)
		}
		get {
			guard let rawValue = objc_getAssociatedObject(self, &AssociatedObjectKeys.ImageTitleStyleKey) as? Int else {
				return .㊧㊨
			}
			return ImageTitleStyle(rawValue: rawValue)!
		}
	}
	
	private(set) var imageTitleSpacing: CGFloat {
		set {
			objc_setAssociatedObject(self, &AssociatedObjectKeys.ImageTitleSpacingKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
		}
		get {
			objc_getAssociatedObject(self, &AssociatedObjectKeys.ImageTitleSpacingKey) as? CGFloat ?? 0
		}
	}
	
    var imageWidth: CGFloat {
        guard let image = imageView?.image else {
            return currentBackgroundImage?.size.width ?? 0
        }
        return image.size.width
    }
    
    var imageHeight: CGFloat {
        guard let image = imageView?.image else {
            return currentBackgroundImage?.size.height ?? 0
        }
        return image.size.height
    }
	
	var titleWidth: CGFloat {
        // 以下两行: 适配iOS14,否则此属性会按照字体的Font返回一个值,从而影响intrinsicContentSize的计算
        guard let titleLabel = titleLabel else { return 0 }
        guard titleLabel.text != .none else { return 0 }
		if #available(iOS 8.0, *) {
			return titleLabel.intrinsicContentSize.width
		} else {
			return titleLabel.frame.size.width
		}
	}
	
	var titleHeight: CGFloat {
        // 以下两行: 适配iOS14,否则此属性会按照字体的Font返回一个值,从而影响intrinsicContentSize的计算
        guard let titleLabel = titleLabel else { return 0 }
        guard titleLabel.text != .none else { return 0 }
		if #available(iOS 8.0, *) {
			return titleLabel.intrinsicContentSize.height
		} else {
			return titleLabel.frame.size.height
		}
	}
	
	/// 可以根据contentEdgeInsets自动适配自身大小
	open override var intrinsicContentSize: CGSize {
		
		var intrinsicWidth: CGFloat = 0.0
		var intrinsicHeight: CGFloat = 0.0
		
		// 计算按钮宽高
		switch imageTitleStyle  {
			case .㊤㊦, .㊦㊤:
				intrinsicWidth = max(imageWidth, titleWidth)
				intrinsicHeight = imageHeight + imageTitleSpacing + titleHeight
			case .㊧㊨, .㊨㊧:
				intrinsicWidth = imageWidth + imageTitleSpacing + titleWidth
				intrinsicHeight = max(imageHeight, titleHeight)
		}
		
		return CGSize(width: intrinsicWidth, height: intrinsicHeight) + contentEdgeInsets
	}
	
	// MARK: - Interface
	
	/// 调整ImageTitle样式
	/// - Parameters:
	///   - style: 样式
	///   - spacing: Image-Title间距(大于等于0; 最好是偶数,否则按钮显示可能会有小小误差)
	func adjustImageTitleStyle(_ style: ImageTitleStyle, spacing: CGFloat = 0) {
		
		assert(spacing >= 0, "A sane person will never do that🤪,right?")
		
		// 赋值
		imageTitleStyle = style
		imageTitleSpacing = spacing
		
		// 声明
		var imageInsets = UIEdgeInsets.zero
		var titleInsets = UIEdgeInsets.zero
		
		/// 根据ContentVerticalAlignment和ContentHorizontalAlignment
		/// 以及ImageTitleStyle确定最终的Image/Title的EdgeInsets
		/// - 说明:
		///  - 平时使用最多的就是水平和垂直方向都居中的情况了,其他情况只为了加深印象
		switch (contentVerticalAlignment, contentHorizontalAlignment) {
			case (.center, .center):
				switch style {
					case .㊤㊦:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
					case .㊧㊨:
						let offset = spacing/2
						imageInsets = UIEdgeInsets(top: 0, left: -offset, bottom: 0, right: offset)
						titleInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: -offset)
					case .㊦㊤:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
					case .㊨㊧:
						let imageOffset = titleWidth + spacing/2
						let titleOffset = imageWidth + spacing/2
						imageInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
						titleInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
				}
			case (.top, .left):
				switch style {
					case .㊤㊦:
						titleInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth, bottom: 0, right: 0)
					case .㊧㊨:
						titleInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
					case .㊦㊤:
						imageInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: 0)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .㊨㊧:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
				}
			case (.top, .right):
				switch style {
					case .㊤㊦:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth-spacing, bottom: 0, right: 0)
					case .㊧㊨:
						imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
					case .㊦㊤:
						imageInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .㊨㊧:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
				}
			case (.bottom, .left):
				switch style {
					case .㊤㊦:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: titleHeight+spacing, right: 0)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .㊧㊨:
						titleInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
					case .㊦㊤:
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
					case .㊨㊧:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
				}
			case (.bottom, .right):
				switch style {
					case .㊤㊦:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: titleHeight+spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .㊧㊨:
						imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
					case .㊦㊤:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
					case .㊨㊧:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
				}
			case (.center, .left):
				switch style {
					case .㊤㊦:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
					case .㊧㊨:
						titleInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
					case .㊦㊤:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
					case .㊨㊧:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
				}
			default:
				break
		}
		
		// 赋值
		titleEdgeInsets = titleInsets
		imageEdgeInsets = imageInsets
		
		invalidateIntrinsicContentSize()
	}
}
