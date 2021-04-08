//
//  ExtensionButton.swift
//  
//
//  Created by Choi on 2020/7/22.
//

import UIKit

extension UIButton {
	
	enum ImageTitleAxis: Int {
		case down
		case right
		case up
		case left
	}
	
	private enum Key {
		static var imageTitleAxis = UUID()
		static var imageTitleSpacing = UUID()
		static var useBackgroundImageSize = UUID()
	}
	
	// MARK: - Properties
	
	var useBackgroundImageSize: Bool {
		set { objc_setAssociatedObject(self, &Key.useBackgroundImageSize, newValue, .OBJC_ASSOCIATION_ASSIGN) }
		get { objc_getAssociatedObject(self, &Key.useBackgroundImageSize) as? Bool ?? false }
	}
	
	private(set) var imageTitleAxis: ImageTitleAxis {
		set { objc_setAssociatedObject(self, &Key.imageTitleAxis, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN) }
		get {
			guard let rawValue = objc_getAssociatedObject(self, &Key.imageTitleAxis) as? Int else {
				return .right
			}
			return ImageTitleAxis(rawValue: rawValue).unsafelyUnwrapped
		}
	}
	
	private(set) var imageTitleSpacing: CGFloat {
		set { objc_setAssociatedObject(self, &Key.imageTitleSpacing, newValue, .OBJC_ASSOCIATION_ASSIGN) }
		get { objc_getAssociatedObject(self, &Key.imageTitleSpacing) as? CGFloat ?? 0 }
	}
	
	var imageWidth: CGFloat { currentImage?.size.width ?? 0 }
	var imageHeight: CGFloat { currentImage?.size.height ?? 0 }
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
		
		let backgroundImageSize = currentBackgroundImage?.size ?? .zero
		var regularSize: CGSize {
			// 初始化size
			var size = CGSize.zero
			// 计算宽高
			switch imageTitleAxis  {
				case .down, .up:
					size.width = max(imageWidth, titleWidth)
					size.height = imageHeight + imageTitleSpacing + titleHeight
				case .right, .left:
					size.width = imageWidth + imageTitleSpacing + titleWidth
					size.height = max(imageHeight, titleHeight)
			}
			return size + contentEdgeInsets
		}
		
		return useBackgroundImageSize ? backgroundImageSize : regularSize
	}
	
	// MARK: - Interface
	
	/// 设置Image-Title布局
	/// - Parameters:
	///   - axis: 布局轴线
	///   - spacing: Image-Title间距(大于等于0; 最好是偶数,否则按钮显示可能会有小小误差)
	func setImageTitleAxis(_ axis: ImageTitleAxis = .right, spacing: CGFloat = 0) {
		
		assert(spacing >= 0, "A sane person will never do that🤪,right?")
		
		// 赋值
		imageTitleAxis = axis
		imageTitleSpacing = spacing
		
		// 声明
		var imageInsets = UIEdgeInsets.zero
		var titleInsets = UIEdgeInsets.zero
		let halfSpacing = spacing / 2.0
		
		/// 根据ContentVerticalAlignment和ContentHorizontalAlignment
		/// 以及ImageTitleStyle确定最终的Image/Title的EdgeInsets
		/// - 说明:
		///  - 平时使用最多的就是水平和垂直方向都居中的情况了,其他情况只为了加深印象
		switch (contentVerticalAlignment, effectiveContentHorizontalAlignment) {
			
			case (.center, .center):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
					case .right:
						imageInsets = UIEdgeInsets(top: 0, left: -halfSpacing, bottom: 0, right: halfSpacing)
						titleInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: -halfSpacing)
					case .up:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
					case .left:
						let imageOffset = titleWidth + halfSpacing
						let titleOffset = imageWidth + halfSpacing
						imageInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
						titleInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
				}
			case (.center, .left):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
					case .right:
						titleInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
					case .up:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
					case .left:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
				}
			case (.center, .right):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-spacing, right: 0)
					case .right:
						imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
					case .up:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: 0, right: 0)
					case .left:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
				}
			case (.top, .left):
				switch axis {
					case .down:
						titleInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth, bottom: 0, right: 0)
					case .right:
						titleInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
					case .up:
						imageInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: 0)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .left:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
				}
			case (.top, .center):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth, bottom: 0, right: 0)
					case .right:
						imageInsets = UIEdgeInsets(top: 0, left: -halfSpacing, bottom: 0, right: halfSpacing)
						titleInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: -halfSpacing)
					case .up:
						imageInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .left:
						let imageOffset = titleWidth + halfSpacing
						let titleOffset = imageWidth + halfSpacing
						imageInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
						titleInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
				}
			case (.top, .right):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth-spacing, bottom: 0, right: 0)
					case .right:
						imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
					case .up:
						imageInsets = UIEdgeInsets(top: titleHeight+spacing, left: 0, bottom: -titleHeight-spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .left:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
				}
			case (.bottom, .left):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: titleHeight+spacing, right: 0)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .right:
						titleInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: -spacing)
					case .up:
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
					case .left:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth+spacing, bottom: 0, right: -titleWidth-spacing)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
				}
			case (.bottom, .center):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: titleHeight+spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: imageHeight+spacing, left: -imageWidth, bottom: 0, right: 0)
					case .right:
						imageInsets = UIEdgeInsets(top: 0, left: -halfSpacing, bottom: 0, right: halfSpacing)
						titleInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: -halfSpacing)
					case .up:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
					case .left:
						let imageOffset = titleWidth + halfSpacing
						let titleOffset = imageWidth + halfSpacing
						imageInsets = UIEdgeInsets(top: 0, left: imageOffset, bottom: 0, right: -imageOffset)
						titleInsets = UIEdgeInsets(top: 0, left: -titleOffset, bottom: 0, right: titleOffset)
				}
			case (.bottom, .right):
				switch axis {
					case .down:
						imageInsets = UIEdgeInsets(top: -titleHeight-spacing, left: 0, bottom: titleHeight+spacing, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: 0)
					case .right:
						imageInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
					case .up:
						imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: -imageHeight-spacing, left: -imageWidth, bottom: imageHeight+spacing, right: 0)
					case .left:
						imageInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -titleWidth)
						titleInsets = UIEdgeInsets(top: 0, left: -imageWidth-spacing, bottom: 0, right: imageWidth+spacing)
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
