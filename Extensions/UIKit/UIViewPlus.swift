//
//  UIViewPlus.swift
//  ExtensionDemo
//
//  Created by Choi on 2021/1/14.
//  Copyright © 2021 Choi. All rights reserved.
//

import UIKit
import SwiftUI

extension UIView {
	
	convenience init(_ color: UIColor) {
		self.init(frame: .zero)
		backgroundColor = color
	}
	
	static func cornerRadius(_ cornerRadius: CGFloat, color: UIColor = .white) -> UIView {
		UIView.new { make in
			make.backgroundColor = color
			make.layer.cornerRadius = cornerRadius
		}
	}
}

// MARK: - __________ Getters __________
extension UIView {
	
	func snapshotScreen(scrollView: UIScrollView) -> UIImage?{
		if UIScreen.main.responds(to: #selector(getter: UIScreen.scale)) {
			UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, UIScreen.main.scale)
		} else {
			UIGraphicsBeginImageContext(scrollView.contentSize)
		}
		
		let savedContentOffset = scrollView.contentOffset
		let savedFrame = scrollView.frame
		let contentSize = scrollView.contentSize
		let oldBounds = scrollView.layer.bounds
		
		if #available(iOS 13, *) {
			//iOS 13 系统截屏需要改变tableview 的bounds
			scrollView.layer.bounds = CGRect(x: oldBounds.origin.x, y: oldBounds.origin.y, width: contentSize.width, height: contentSize.height)
		}
		//偏移量归零
		scrollView.contentOffset = CGPoint.zero
		//frame变为contentSize
		scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
		
		//截图
		if let context = UIGraphicsGetCurrentContext() {
			scrollView.layer.render(in: context)
		}
		if #available(iOS 13, *) {
			scrollView.layer.bounds = oldBounds
		}
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		//还原frame 和 偏移量
		scrollView.contentOffset = savedContentOffset
		scrollView.frame = savedFrame
		return image
	}
	
	private func getTableViewScreenshot(tableView: UITableView,whereView: UIView) -> UIImage?{
		// 创建一个scrollView
		let scrollView = UIScrollView()
		// 设置颜色
		scrollView.backgroundColor = UIColor.white
		// 设置位置
		scrollView.frame = whereView.bounds
		// 设置滚动位置
		scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tableView.contentSize.height)
		// 将tableView加载到视图中
		scrollView.addSubview(tableView)
		// 设置位置
		let constraints = [
			tableView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			tableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
			tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
			tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
		]
		NSLayoutConstraint.activate(constraints)
		/// 添加到指定视图
		whereView.addSubview(scrollView)
		/// 截图
		let image = snapshotScreen(scrollView: scrollView)
		/// 移除scrollView
		scrollView.removeFromSuperview()
		return image
	}

	var snapshot: UIImage? {
		switch self {
			case let unwrapped where unwrapped is UITableView:
				let tableView = unwrapped as! UITableView
				return getTableViewScreenshot(tableView: tableView, whereView: superview!)
			default:
				// 参数①：截屏区域  参数②：是否透明  参数③：清晰度
				UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
				layer.render(in: UIGraphicsGetCurrentContext()!)
				let image = UIGraphicsGetImageFromCurrentImageContext()

				UIGraphicsEndImageContext()
				return image
		}
	}
	
	/// 获取View控制器实例
	var owner: UIViewController? {
		owner(UIViewController.self)
	}
	
	/// 获取View的控制器
	/// - Parameter type: 控制器类型
	/// - Returns: 控制器实例
	func owner<VC: UIViewController>(_ type: VC.Type) -> VC? {
		var parent: UIResponder? = self
		while parent != nil {
			parent = parent?.next
			if let controller = parent as? VC {
				return controller
			}
		}
		return nil
	}
}

// MARK: - __________ Functions __________
extension Array where Element: UIView {
	
	/// 将UIView的数组包装的StackView里
	/// - Returns: The stack view wrapping the given view array as arranged subviews.
	func embedInStackView(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .leading,
		spacing: CGFloat = 0)
	-> UIStackView {
		let stackView = UIStackView(arrangedSubviews: self)
		stackView.axis = axis
		stackView.distribution = distribution
		stackView.alignment = alignment
		stackView.spacing = spacing
		return stackView
	}
}
extension UIView {
	private enum Associated {
		static var shadowViewKey = UUID()
	}
	private var shadowView: UIView {
		guard let shadow = objc_getAssociatedObject(self, &Associated.shadowViewKey) as? UIView else {
			let shadow = UIView(frame: bounds)
			shadow.autoresizingMask = [
				.flexibleWidth,
				.flexibleHeight
			]
			shadow.isUserInteractionEnabled = false
			shadow.backgroundColor = .clear
			shadow.layer.masksToBounds = false
			shadow.layer.shouldRasterize = true
			shadow.layer.rasterizationScale = UIScreen.main.scale
			objc_setAssociatedObject(self, &Associated.shadowViewKey, shadow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return shadow
		}
		return shadow
	}
	
	
	/// 为视图添加圆角和阴影 | 只在frame确定的时候才能调用此方法
	/// - Parameters:
	///   - corners: 圆角效果施加的角
	///   - cornerRadius: 圆角大小
	///   - shadowColor: 阴影颜色: 不为空才添加阴影
	///   - shadowOffsetX: 阴影偏移X
	///   - shadowOffsetY: 阴影偏移Y
	///   - shadowRadius: 阴影大小
	///   - shadowOpacity: 阴影透明度
	///   - shadowExpansion: 阴影扩大值:大于零扩大; 小于零收缩; 0:默认值
	func roundCorners(corners: UIRectCorner = .allCorners,
					  cornerRadius: Double = 0.0,
					  withShadowColor shadowColor: UIColor? = nil,
					  shadowOffset: (x: Double, y: Double) = (0, 0),
					  shadowRadius: CGFloat = 0,
					  shadowOpacity: Float = 0,
					  shadowExpansion: CGFloat = 0) {
		// 圆角
		var bezier = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
		)
		if cornerRadius > 0 {
			let shape = CAShapeLayer()
			shape.path = bezier.cgPath
			layer.mask = shape
		}
		
		// 阴影
		if let shadowColor = shadowColor {
			// 调整阴影View的frame
			shadowView.frame = frame
			// 设置阴影属性
			shadowView.layer.shadowColor = shadowColor.cgColor
			shadowView.layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
			shadowView.layer.shadowRadius = shadowRadius
			shadowView.layer.shadowOpacity = shadowOpacity
			// 设置阴影形状
			if shadowExpansion != 0 {
				let insets = UIEdgeInsets(
					top: -shadowExpansion,
					left: -shadowExpansion,
					bottom: -shadowExpansion,
					right: -shadowExpansion
				)
				bezier = UIBezierPath(
					roundedRect: bounds.inset(by: insets),
					byRoundingCorners: corners,
					cornerRadii: CGSize(width:cornerRadius, height:cornerRadius)
				)
			}
			shadowView.layer.shadowPath = bezier.cgPath
			if let superView = superview {
				superView.insertSubview(shadowView, belowSubview: self)
			}
		}
	}
}
#if DEBUG
// MARK: - __________ SwiftUI __________
extension UIView {

	var previewLayout: PreviewLayout {
		let previewSize = systemLayoutSizeFitting(
			CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude),
			withHorizontalFittingPriority: .required,
			verticalFittingPriority: .fittingSizeLevel
		)
		return .fixed(width: previewSize.width, height: previewSize.height)
	}
	
	private struct Preview: UIViewRepresentable {
		
		let view: UIView

		func makeUIView(context: Context) -> UIView { view }

		func updateUIView(_ uiView: UIView, context: Context) { }
	}

	var preview: some View {
		// 如何遇见切换UIView和UIView(带设备边框)的情况,可尝试把整个项目关闭在重新打开; 或清除Preview缓存:
		// .../Xcode/DerivedData/TargetFolder.../Build/Intermediates.noindex/Previews
		Preview(view: self)
//			.previewLayout(.device)
			.previewLayout(previewLayout)
	}
}
#endif
